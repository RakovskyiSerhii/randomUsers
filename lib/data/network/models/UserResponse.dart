class UserResponse {
    String? email;
    NameResponse? name;
    PictureResponse? picture;

    UserResponse({this.email, this.name, this.picture});

    factory UserResponse.fromJson(Map<String, dynamic> json) {
        return UserResponse(
            email: json['email'], 
            name: json['name'] != null ? NameResponse.fromJson(json['name']) : null, 
            picture: json['picture'] != null ? PictureResponse.fromJson(json['picture']) : null, 
        );
    }
}

class PictureResponse {
    String? large;
    String? medium;
    String? thumbnail;

    PictureResponse({this.large, this.medium, this.thumbnail});

    factory PictureResponse.fromJson(Map<String, dynamic> json) {
        return PictureResponse(
            large: json['large'], 
            medium: json['medium'], 
            thumbnail: json['thumbnail'], 
        );
    }
}

class NameResponse {
    String? first;
    String? last;

    NameResponse({this.first, this.last});

    factory NameResponse.fromJson(Map<String, dynamic> json) {
        return NameResponse(
            first: json['first'], 
            last: json['last'], 
        );
    }
}