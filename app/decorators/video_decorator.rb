class VideoDecorator < Draper::Decorator
  delegate_all

  def rating
    if object.average_rating
      "#{object.average_rating}/5.0"
    else
      "N/A"
    end
  end
end
