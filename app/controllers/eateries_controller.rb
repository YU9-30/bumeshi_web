class EateriesController < ApplicationController
    
    def index
        @eateries = Eatery.recent(50).page(params[:page])
    end
    def new
        if params[:name].present? and params[:address].present?
            addres = params[:address]
            addres.slice!(0..9)
            @eatery = Eatery.new(
                name: params[:name], 
                addres: addres, 
                latitude: params[:latitude], 
                longitude: params[:longitude],
                parking: nil,
                url: params[:url],
                gnav_id: params[:gnav_id],
            )
        else
            @eatery = Eatery.new(flash[:eatery])
        end
    end
    def find
        @gnavi_query = params[:query]
        @gnavi_eateries = gnavi_freeword_search(@gnavi_query)
    end
    def create
        eatery = Eatery.new(eatery_params)
        if eatery.save 
            flash[:notice] = "#{eatery.name}を登録しました😘"
            redirect_to eatery_url(id: eatery.id)
        else
            flash[:eatery] = eatery
            flash[:error_messages] = eatery.errors.full_messages
            redirect_back fallback_location: root_path
        end
    end
    
    def show
       @eatery = Eatery.find(params[:id])
       @reviews = Review.where(eatery_id: params[:id])
       @image_url = rails_representation_url(@eatery.image.variant(gravity: :center, resize:"1200x630^", crop:"1280x720+0+0"))
    end
    
    def all
       @eateries = Eatery.page(params[:page])
    end
    def search
        @query = params[:query]
        @eateries = Eatery.search(@query).page(params[:page])
    end
    
    private
    
    def eatery_params
        params.require(:eatery).permit(:name, :addres, :latitude, :longitude, :parking, :url, :gnav_id, :image, payment_ids: [], category_ids: [])
    end
    def gnavi_freeword_search(querey)
        q = querey
        key=ENV['API_KEY']
        params = URI.encode_www_form({keyid: key, freeword: q})
        uri = URI.parse("https://api.gnavi.co.jp/RestSearchAPI/v3/?#{params}")
        json = Net::HTTP.get(uri)
        result = JSON(json)
        
        return result["rest"]
    end
end