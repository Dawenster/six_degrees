module DreamHelper
  def background_image(dream)
    tag = dream.tags.sample
    case tag.try(:name)
    when Tag::TRAVEL
      "https://s3-us-west-2.amazonaws.com/six-degrees-app/general/travel.png"
    when Tag::CAREER_GOALS
      "https://s3-us-west-2.amazonaws.com/six-degrees-app/general/career.png"
    when Tag::PERSONAL_GROWTH
      "https://s3-us-west-2.amazonaws.com/six-degrees-app/general/personal_growth.png"
    when Tag::FOR_A_BETTER_WORLD
      "https://s3-us-west-2.amazonaws.com/six-degrees-app/general/for_a_better_world.png"
    when Tag::FAN_CLUB
      "https://s3-us-west-2.amazonaws.com/six-degrees-app/general/fan_club.png"
    else
      "https://s3-us-west-2.amazonaws.com/six-degrees-app/general/fan_club.png"
    end
  end
end
