#!/bin/bash
# コンテナ内部で初回のみ実行します

chmod 777 -R storage
chmod 777 -R bootstrap/cache

php artisan migrate
npm install && npm run dev

# Voyager
php artisan voyager:install --with-dummy
# admin@admin.com : password

php artisan migrate:refresh --seed
php artisan db:seed
php artisan voyager:install --with-dummy



# ゲストユーザー用のUIを生成
sed -i -e "s/return view('welcome');/\$posts = App\\\\Post::all();\n    return view('home', compact('posts'));/" routes/web.php

php artisan make:model Post

cat <<'EOF' > resources/views/home.blade.php
@extends('layouts.app')

@section('content')
<div class="container">
  <div class="row justify-content-center mb-3">
    <div class="col-md-8">
      <div class="card">
        <div class="card-header">{{ __('Dashboard') }}</div>
        <div class="card-body">
          ようこそ！
        </div>
      </div>
    </div>
  </div>
  <div class="album py-5 bg-light">
    <div class="container">
      <div class="row">
@foreach($posts as $post)
        <div class="col-md-4">
          <div class="card mb-4 shadow-sm">
            <a href="/post/{{ $post->slug }}">
@if(strlen($post->image)>0)
              <img class="card-img-top" src="{{ Voyager::image( $post->image ) }}" alt="{{ $post->title }}">
@endif
            </a>
            <div class="card-body">
              <p class="card-text">
                <a href="/post/{{ $post->slug }}">
                  {{ $post->title }}
                </a>
              </p>
            </div>
          </div>
        </div>
@endforeach
      </div>
    </div>
  </div>
</div>
@endsection
EOF

sed -i -e "s/<link href=\"{{ asset('css\/app.css') }}\" rel=\"stylesheet\">/<link href=\"{{ asset('css\/app.css') }}\" rel=\"stylesheet\">\n    <link rel=\"stylesheet\" href=\"https:\/\/cdn.jsdelivr.net\/npm\/bootstrap@4.5.3\/dist\/css\/bootstrap.min.css\" integrity=\"sha384-TX8t27EcRE3e\/ihU7zmQxVncDAy5uIKz4rEkgIXeMed4M0jlfIDPvg6uqKI2xXr2\" crossorigin=\"anonymous\">/" resources/views/layouts/app.blade.php

sed -i -e "s/<\/body>/<\/body><script src=\"https:\/\/code.jquery.com\/jquery-3.5.1.slim.min.js\" integrity=\"sha384-DfXdz2htPH0lsSSs5nCTpuj\/zy4C+OGpamoFVy38MVBnE+IbbVYUew+OrCXaRkfj\" crossorigin=\"anonymous\"><\/script><script src=\"https:\/\/cdn.jsdelivr.net\/npm\/bootstrap@4.5.3\/dist\/js\/bootstrap.bundle.min.js\" integrity=\"sha384-ho+j7jyWK8fNQe+A12Hb8AhRq26LrZ\/JpcUGGOn+Y7RsweNrtN\/tE3MoK7ZeZDyx\" crossorigin=\"anonymous\"><\/script>/" resources/views/layouts/app.blade.php

sed -i -e "s/Auth::routes();/Route::get('post\/{slug}', function(\$slug){\n    \$post = App\\\\Post::where('slug', '=', \$slug)->firstOrFail();\n    \$author_name = (0 == \$post->author_id) ? 'System' : App\\\\User::where('id', '=', \$post->author_id)->firstOrFail()->name;\n    return view('post', compact('post', 'author_name'));\n});\n\nAuth::routes();/" routes/web.php

cat <<'EOF' > resources/views/post.blade.php
@extends('layouts.app')

@section('content')
<div class="container">
  <div class="row">
    <div class="col">
      <div class="card">
        <div class="card-header p-3">
          <h1>{{ $post->title }}</h1>
        </div>
@if(strlen($post->image)>0)
        <img class="bd-placeholder-img card-img-top" src="{{ Voyager::image( $post->image ) }}" style="width:100%">
@endif
        <div class="card-body">
          <h5 class="card-title">{{ $post->excerpt }}</h5>
          <p class="card-text my-5">{!! $post->body !!}</p>
          <p class="card-text my-5 text-right px-5">
            <a href="#" class="btn btn-outline-warning">Favorite</a>
          </p>
        </div>
        <div class="card-footer text-muted text-right px-5">
          Created by {{ $author_name }} at {{ $post->created_at }}
        </div>
      </div>
    </div>
  </div>
</div>
@endsection
EOF
