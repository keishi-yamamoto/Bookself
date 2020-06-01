class Users::SearchController < ApplicationController
  # 未発売の商品を弾くために導入
  require 'date'
  require 'json'

  def search_api
    if params[:keyword]
      # 検索ワードの整形
      keyword = params[:keyword].strip
      uri = URI.parse(URI.encode("https://app.rakuten.co.jp/services/api/BooksBook/Search/20170404?format=json&title=#{keyword}&outOfStockFlag=1&sort=-releaseDate&formatVersion=2&applicationId=#{ENV['RWS_APPLICATION_ID']}"))
      json = Net::HTTP.get(uri)
      @results = date_prefix(JSON.parse(json))
      sort_by_date(@results)
    end
    render :index
  end

  def index
  end

  private
  # salesDateのフォーマットを整える
  def date_prefix(results)
    if results['count'] != 0
      results['Items'].each do |item|
        # salesDateを取り出してその文字列に対してregex
        date = item['salesDate']
        date = date.gsub(/頃/,'')
        date = date.gsub(/\A\d{4}.\z/,'\&1月')
        date = date.gsub(/\A\d{4}.\d{2}.\z/,'\&1日')
        date = Date.strptime(date, '%Y年%m月%d日')
        item['salesDate'] = date
      end
    else
      # 検索結果0の場合
      false
    end
  end

  # 発売日が今日までのものだけを表示する
  def sort_by_date(results)
    if results
      @items = []
      results.each do |item|
        if Date.today > item['salesDate']
          @items.push(item)
        end
      end
    end
  end
end
