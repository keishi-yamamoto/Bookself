class Users::SearchController < ApplicationController
  before_action :authenticate_user!

  # 未発売の商品を弾くために導入
  require 'date'
  require 'json'

  def search_api
    if params[:keyword_new]
      # 検索ワードの整形
      keyword = params[:keyword_new].strip
      uri = URI.parse(URI.encode("https://app.rakuten.co.jp/services/api/BooksBook/Search/20170404?format=json&title=#{keyword}&outOfStockFlag=1&sort=-releaseDate&formatVersion=2&applicationId=#{ENV['RWS_APPLICATION_ID']}"))
      json = Net::HTTP.get(uri)
      # api側のエラーの場合も検索結果0を返す
      unless JSON.parse(json)["error"].present?
        @results = date_prefix(JSON.parse(json))
        sort_by_date(@results)
        split_title(@items)
      end
    end
    render :index
  end

  # search_apiの結果表示
  def index
  end

  # DB内のデータ（ユーザ、書籍を）検索するためのページ
  def total
  end

  # indexにおけるmodalの情報処理
  def book_title
    title = params[:title].split(',')
    @items = []
    n = 0
    title.count.times do
      results = Title.where('name like ?', "%#{title[n]}%")
      if results.present?
        # 存在する書籍をすべて@itemsに追加する
        i = 0
        results.count.times do
          @items.push(results[i])
          i += 1
        end
      end
      n += 1
    end
    # 重複して追加したものを削除
    @items.uniq!
    render json: @items
  end

  # ユーザ、登録タイトル総合検索
  def results
    keyword = params[:keyword_db].strip
    # id検索をした際に@を半角に整形
    keyword.gsub(/＠/,"@")
    # Title,Userそれぞれの結果を入れるための形で配列を生成
    @title_results = []
    @user_results = []
    # タイトルあいまい検索
    title_results = Title.where('name like ?', "%#{keyword}%")
    if title_results.present?
      i = 0
      title_results.count.times do
        @title_results.push(title_results[i])
        i += 1
      end
      @title_results.uniq!
    end
    # ユーザ名あいまい検索
    user_results = User.where('name like ?', "%#{keyword}%")
    if user_results.present?
      i = 0
      user_results.count.times do
        @user_results.push(user_results[i])
        i += 1
      end
    end
    # ユーザidあいまい検索
    if keyword[0] == "@"
      user_results_by_id = User.where('elastic_id like ?', "%#{keyword[1,keyword.length]}%")
      i = 0
      user_results_by_id.count.times do
        @user_results.push(user_results_by_id[i])
        i += 1
      end
    end
    unless @user_results.blank?
      @user_results.uniq!
    end
    render :total
  end

  private
  # salesDateのフォーマットを整える
  def date_prefix(results)
    if results['count'] != 0
      results['Items'].each do |item|
        # salesDateを取り出してその文字列に対してregex
        date = item['salesDate']
        date = date.gsub(/頃|下旬|中旬|上旬/,'')
        date = date.gsub(/\A\d{4}.\z/,'\&1月')
        date = date.gsub(/\A\d{4}.\d{2}.\z/,'\&1日')
        date = date.gsub(/\A\d{4}.\d{1}.\z/,'\&1日')
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

  # 書籍タイトルの分割
  def split_title(results)
    if results
      @titles = []
      results.each do |item|
        title = item['title']
        # 全角スペースを半角に,半角スペースで区切る
        title = item['title'].gsub(/\p{blank}/,' ').split(' ')
        @titles.push(title)
      end
    end
  end
end
