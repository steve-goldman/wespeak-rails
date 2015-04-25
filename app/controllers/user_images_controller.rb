class UserImagesController < ApplicationController

  def create
    user = User.find_by(id: params[:id])

    if !user
      render json: {
               error: {
                 message: "Invalid user: #{params[:id]}"
               }
             }, content_type: "text/html"
    else
      user_image = UserImage.create(user_id: user.id, image: params[:file])
      if !user_image.valid?
        render json: {
                 error: {
                   message: user_image.errors.to_a.join(",")
                 }
               }, content_type: "text/html"
      else
        render json: {
                 image: {
                   url: user_image.image.url
                 }
               }, content_type: "text/html"
      end
    end
  end
  
end
