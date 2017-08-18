class DistrictsController < ApplicationController


  def home
      #@home = home
  end



  def show
    @district = District.find(params[:id])




    bill_response = HTTParty.get("https://www.govtrack.us/api/v2/bill?congress=115&order_by=-current_status_date")
    @bill_json = JSON.parse(bill_response.body)



    @objects_hash = @bill_json.fetch("objects")
 #   @bills = @objects_hash.fetch("")

    @bills = []

    @objects_hash.each do |h|

      if h.has_value?("passed_bill") || h.has_value?("enacted_signed")  || h.has_value?("pass_over_senate")
        @bills << h
      end
    end

  end

  def address
  end
  
  
  
  
  
  
  def parse_address
    @street = params[:Street]
    # IMPORTANT! Change api key to <%= ENV["MAPS_API_KEY"] %> and git ignore secrets.yml after getting new uncompromised api from Google
    response = HTTParty.get("https://www.googleapis.com/civicinfo/v2/representatives?key=AIzaSyDAScfx_c-PTavuWMLSGRsWSQDTpCeW1Cg&address=#{@street}")
    @json = JSON.parse(response.body)
   
#Determines Congressional District 
  if @json.key?("divisions") == false
    redirect_to root_url
  else

    @division_hash = @json.fetch("divisions")
    @ocd_division = @division_hash.keys[2] 
    @district_hash = @division_hash.fetch(@ocd_division)
#    @district_name = @district_hash.fetch("name").titleize

#Creates Hash Of All Office Holders In District    
    @office_holders_hash = @json.fetch("officials")
    
# US Senator One
    @senator_one_hash = @office_holders_hash[2]
 #   @senator_one_name = @senator_one_hash.fetch("name")
 #   @senator_one_party = @senator_one_hash.fetch("party")
 #   @senator_one_photo_url = @senator_one_hash.fetch("photoUrl")
    @senator_one_websites_array = @senator_one_hash.fetch("urls")
 #   @senator_one_website = @senator_one_websites_array[0]

    #US Senator One Social Media
    @senator_one_socials_array = @senator_one_hash.fetch('channels', nil)
    
    
    if @senator_one_socials_array == nil
        @senator_one_facebook = nil
        @senator_one_twitter = nil
    else
     @senator_one_socials_array.each do |hash|
        if hash.has_value?("Facebook") 
          @senator_one_facebook = hash.fetch("id")
        elsif hash.has_value?("Twitter")
          @senator_one_twitter = hash.fetch("id")
        end
      end
    end


# US Senator Two
    @senator_two_hash = @office_holders_hash[3]
#    @senator_two_name = @senator_two_hash.fetch("name")
#    @senator_two_party = @senator_two_hash.fetch("party")
#    @senator_two_photo_url = @senator_two_hash.fetch("photoUrl")
    @senator_two_websites_array = @senator_two_hash.fetch("urls")
#    @senator_two_website = @senator_two_websites_array[0]

    #US Senator Two Social Media
    @senator_two_socials_array = @senator_two_hash.fetch('channels', nil)
    
    
    if @senator_two_socials_array == nil
        @senator_two_facebook = nil
        @senator_two_twitter = nil
    else
     @senator_two_socials_array.each do |hash|
        if hash.has_value?("Facebook") 
          @senator_two_facebook = hash.fetch("id")
        elsif hash.has_value?("Twitter")
          @senator_two_twitter = hash.fetch("id")
        end
      end
    end

# US Rep 
    @us_rep_hash = @office_holders_hash[4]
#    @us_rep_name = @us_rep_hash.fetch("name")
#    @us_rep_party = @us_rep_hash.fetch("party")
#    @us_rep_photo_url = @us_rep_hash.fetch("photoUrl")
    @us_rep_websites_array = @us_rep_hash.fetch("urls")
#    @us_rep_website = @us_rep_websites_array[0]

    #US Rep Social Media
    @us_rep_socials_array = @us_rep_hash.fetch('channels', nil)
    
    
    if @us_rep_socials_array == nil
        @us_rep_facebook = nil
        @us_rep_twitter = nil
    else
     @us_rep_socials_array.each do |hash|
        if hash.has_value?("Facebook") 
          @us_rep_facebook = hash.fetch("id")
        elsif hash.has_value?("Twitter")
          @us_rep_twitter = hash.fetch("id")
        end
      end
    end
  
      @district = District.where(:district_name => @district_hash.fetch("name").titleize).first_or_create
 
      @district.district_name = @district_hash.fetch("name").titleize
      
      @district.senator_one_name = @senator_one_hash.fetch('name', nil)
      @district.senator_one_party = @senator_one_hash.fetch('party', nil)
      @district.senator_one_photo_url = @senator_one_hash.fetch('photoUrl', nil)
      @district.senator_one_website = @senator_one_websites_array[0]
      @district.senator_one_facebook = @senator_one_facebook
      @district.senator_one_twitter = @senator_one_twitter

      @district.senator_two_name = @senator_two_hash.fetch('name', nil)
      @district.senator_two_party = @senator_two_hash.fetch('party', nil)
      @district.senator_two_photo_url = @senator_two_hash.fetch('photoUrl', nil)
      @district.senator_two_website = @senator_two_websites_array[0]
      @district.senator_two_facebook = @senator_two_facebook
      @district.senator_two_twitter = @senator_two_twitter

      @district.us_rep_name = @us_rep_hash.fetch('name', nil)
      @district.us_rep_party = @us_rep_hash.fetch('party', nil)
      @district.us_rep_photo_url = @us_rep_hash.fetch('photoUrl', nil)
      @district.us_rep_website = @us_rep_websites_array[0]
      @district.us_rep_facebook = @us_rep_facebook
      @district.us_rep_twitter = @us_rep_twitter


      @district.save
 #     @district

      redirect_to district_path(@district)
    end
  
  end
  
  def bills
    bill_response = HTTParty.get("https://www.govtrack.us/api/v2/bill?congress=115&order_by=-current_status_date")
    @bill_json = JSON.parse(bill_response.body)



    @objects_hash = @bill_json.fetch("objects")
 #   @bills = @objects_hash.fetch("")

    @bills = []

    @objects_hash.each do |h|

      if h.has_value?("passed_bill") || h.has_value?("enacted_signed")  || h.has_value?("pass_over_senate")
        @bills << h
      end
    end

  end  
  
  
  
  


    private
  

    def district_params
      params.require(:district).permit(:senator_one_name, :senator_one_party, :senator_one_photo_url, :senator_one_website, :senator_one_facebook, :senator_one_twitter, :senator_two_name, :senator_two_party, :senator_two_photo_url, :senator_two_website, :senator_two_facebook, :senator_two_twitter, :us_rep_name, :us_rep_party, :us_rep_photo_url, :us_rep_website, :us_rep_facebook, :us_rep_twitter)
    end


 
end