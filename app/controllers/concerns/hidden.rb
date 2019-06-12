module Hidden
    include ActiveSupport::Concern
    
    def doggy!(*)
        doggy_url = JSON.parse(Faraday.get('https://dog.ceo/api/breeds/image/random').body)['message']
        tempfile = Down.download(doggy_url)
        reply_with :photo, photo: File.open(tempfile)
    end

end
  
  