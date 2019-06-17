class StatusController < ApplicationController 
    def index
        puts request.headers['origin']
        render json: { status: 'OK' }
    end
end
