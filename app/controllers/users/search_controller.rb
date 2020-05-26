class Users::SearchController < ApplicationController
  # 未発売の商品を弾くために導入
  require 'date'

  def search_api
    if params[:keyword]
      uri = URI.parse(URI.encode("https://app.rakuten.co.jp/services/api/BooksBook/Search/20170404?format=json&title=#{params[:keyword]}&outOfStockFlag=1&sort=-releaseDate&formatVersion=2&applicationId=#{ENV['RWS_APPLICATION_ID']}"))
      json = Net::HTTP.get(uri)
      @results = JSON.parse(json)
      byebug
    end
    render :index
  end

  def index
  end

  # salesDateのフォーマットを整え、比較できる形にする
  def date_prefix
    # 正規表現
    # x年y月z日のフォーマットに
    # x-y-zのフォーマットに
  end
end
