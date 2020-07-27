class SightingsController < ApplicationController

    def index
        # All attributes of included objects will be listed by default. 
        # Using include: also works fine when dealing with an action that renders an array, 
        # like when we use all in index actions
        sightings = Sighting.all
        render json: sightings, include: [:bird, :location]

    end

    def show
        sighting = Sighting.find_by(id: params[:id])
        # render json: sighting

        # To include bird and location information in this controller action, now that our models are connected, 
        # the most direct way would be to build a custom hash like we did in the previous lesson:
        # render json: { id: sighting.id, bird: sighting.bird, location: sighting.location } 
        # Often, this works perfectly fine to get yourself started, 
        # and is more than enough to begin testing against with fetch() requests on a frontend

        if sighting
        #An alternative is to use the include option to indicate what models you want to nest:
            # render json: sighting, include: [:bird, :location]
        # or
            # render json: sighting.to_json(include: [:bird, :location], except: [:updated_at])
        # This produces similar JSON as the previous custom configuration


        # For example, to also remove all instances of :created_at and :updated_at from the nested bird and location data in the above example, 
        # we'd have to add nesting into the options, so the included bird and location data can have their own options listed. 
        # Using the fully written to_json render statement can help keep things a bit more readable here

        render json: sighting.to_json(:include => {
            :bird => {:only => [:name, :species]},
            :location => {:only => [:latitude, :longitude]}
          }, :except => [:updated_at])
        
        else 
            render json: { message: 'No sighting found with that id' }
        end
    end

end
