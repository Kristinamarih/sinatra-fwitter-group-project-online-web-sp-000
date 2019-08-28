class TweetsController < ApplicationController
# before_action :set_tweet, only: [:show, :edit, :update, :destroy]

  get '/tweets' do
    if logged_in?
      erb :'/tweets/index'
    else
      redirect '/users/login'
    end
  end

  get '/tweets/new' do
    erb :'/tweets/new'
  end

  post '/tweets' do
    if !logged_in?
      redirect '/'
    end
    if params[:content] != ""
      @tweet = Tweet.create(content: params[:content], user_id: current_user.id)
      redirect "/tweets/#{@tweet.id}"
    else
      redirect '/tweets/new'
    end
  end

  get '/tweets/:id' do
    set_tweet
    erb :'/tweets/show'
  end

  get '/tweets/new' do
    erb :'tweets/new'
  end

  get '/tweets/:id/edit' do
    set_tweet
    if logged_in?
      if authorized?(@tweet)
        erb :'/tweets/edit'
      else
        redirect "/users/#{current_user.id}"
      end
    else
      redirect '/users/login'
    end
  end

  post '/tweets/:id' do
    set_tweet
    if logged_in?
      if @tweet.user == current_user
        @tweet.update(content: params[:content])
        redirect "/tweets/#{@tweet.id}"
      else
        redirect "/users/#{current_user.id}"
      end
    else
      redirect "/login"
    end
  end

  post '/tweets/:id/delete' do
    set_tweet
    if authorized?(@tweet)
      @tweet.destroy
      redirect '/tweets/index'
    else
      redirect '/tweets/index'
    end
  end

  private
  def set_tweet
    @tweet = Tweet.find(params[:id])
  end
end
