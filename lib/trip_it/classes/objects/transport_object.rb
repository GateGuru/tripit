module TripIt
  class TransportObject < ReservationObject
    traveler_array_param :travelers
    
    def initialize(client, obj_id = nil, source = nil)
      @client = client
      unless obj_id.nil?
        @obj_id = obj_id
        populate(source)
      end
    end
    
    def populate(source)
      info = source || @client.get("/transport", :id => @obj_id)["TransportObject"]
      super(info)
      @segments   = []
      @travelers  = []
      chkAndPopulate(@segments, TripIt::TransportSegment, info["Segment"])
      chkAndPopulate(@travelers, TripIt::Traveler, info["Traveler"])
      @segments = @segments.sort_by {|seg| seg.start_date_time } unless @segments.empty?
    end
    
    def segments
      @segments
    end
    def segments=(val)
      if val.is_a?(Array) && val.all? { |e| TransportSegment === e }
        @segments = val
      else
        raise ArgumentError, "#{name} must be an Array of TransportSegments"
      end
    end
  end
end