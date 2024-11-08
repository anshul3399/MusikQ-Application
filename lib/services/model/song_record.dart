const String tableSongs = 'songs';

class SongsDBFields {
  static final List<String> values = [
    songID,
    albumID,
    albumOrSingle,
    songTitle,
    year,
    singers,
    musicDirector,
    lyricist,
    artists,
    resourceType,
    resourceURL,
    thumbnailURL,
    primarySearchLabels,
    secondarySearchLabels,
    likebilityIndex
  ];

  static const String songID = 'Song_ID';
  static const String albumID = 'AlbumID';
  static const String albumOrSingle = 'AlbumOrSingle_Title';
  static const String songTitle = 'Songs';
  static const String year = 'Year';
  static const String singers = 'Singers';
  static const String musicDirector = 'Music_Director';
  static const String lyricist = 'Lyricist';
  static const String artists = 'Artists';
  static const String resourceType = 'Resource_Type';
  static const String resourceURL = 'Resource_URL';
  static const String thumbnailURL = 'Thumbnail_URL';
  static const String primarySearchLabels = 'Primary_Search_Labels';
  static const String secondarySearchLabels = 'Secondary_Search_Labels';
  static const String likebilityIndex = 'Likebility_Index';

  static List<String> getFields() {
    return [
      songID,
      albumID,
      albumOrSingle,
      songTitle,
      year,
      singers,
      musicDirector,
      lyricist,
      artists,
      resourceType,
      resourceURL,
      thumbnailURL,
      primarySearchLabels,
      secondarySearchLabels,
      likebilityIndex
    ];
  }
}

class SongData {
  final String? songID;
  final String? albumID;
  final String? albumOrSingle;
  final String? songTitle;
  final String? year;
  final String? singers;
  final String? musicDirector;
  final String? lyricist;
  final String? artists;
  final String? resourceType;
  final String? resourceURL;
  final String? thumbnailURL;
  final String? primarySearchLabels;
  final String? secondarySearchLabels;
  final String? likebilityIndex;

  const SongData(
      {this.songID,
      required this.albumID,
      required this.albumOrSingle,
      required this.songTitle,
      required this.year,
      required this.singers,
      required this.musicDirector,
      required this.lyricist,
      required this.artists,
      required this.resourceType,
      required this.resourceURL,
      required this.thumbnailURL,
      required this.primarySearchLabels,
      required this.secondarySearchLabels,
      required this.likebilityIndex});

  SongData copy(
          {String? songID,
          String? albumID,
          String? albumOrSingle,
          String? songTitle,
          String? year,
          String? singers,
          String? musicDirector,
          String? lyricist,
          String? artists,
          String? resourceType,
          String? resourceURL,
          String? thumbnailURL,
          String? primarySearchLabels,
          String? secondarySearchLabels,
          String? likebilityIndex}) =>
      SongData(
          songID: songID ?? this.songID,
          albumID: albumID ?? this.albumID,
          albumOrSingle: albumOrSingle ?? this.albumOrSingle,
          songTitle: songTitle ?? this.songTitle,
          year: year ?? this.year,
          singers: singers ?? this.singers,
          musicDirector: musicDirector ?? this.musicDirector,
          lyricist: lyricist ?? this.lyricist,
          artists: artists ?? this.artists,
          resourceType: resourceType ?? this.resourceType,
          resourceURL: resourceURL ?? this.resourceURL,
          thumbnailURL: thumbnailURL ?? this.thumbnailURL,
          primarySearchLabels: primarySearchLabels ?? this.primarySearchLabels,
          secondarySearchLabels:
              secondarySearchLabels ?? this.secondarySearchLabels,
          likebilityIndex: likebilityIndex ?? this.likebilityIndex);

  static SongData fromJson(Map<String, dynamic> json) => SongData(
      songID: json[SongsDBFields.songID] as String?,
      albumID: json[SongsDBFields.albumID] as String,
      albumOrSingle: json[SongsDBFields.albumOrSingle] as String,
      songTitle: json[SongsDBFields.songTitle] as String,
      year: json[SongsDBFields.year],
      singers: json[SongsDBFields.singers] as String,
      musicDirector: json[SongsDBFields.musicDirector] as String,
      lyricist: json[SongsDBFields.lyricist] as String,
      artists: json[SongsDBFields.artists] as String,
      resourceType: json[SongsDBFields.resourceType] as String,
      resourceURL: json[SongsDBFields.resourceURL] as String,
      thumbnailURL: json[SongsDBFields.thumbnailURL] as String,
      primarySearchLabels: json[SongsDBFields.primarySearchLabels] as String,
      secondarySearchLabels:
          json[SongsDBFields.secondarySearchLabels] as String,
      likebilityIndex: json[SongsDBFields.likebilityIndex] as String);

  Map<String, dynamic> toJson() => {
        SongsDBFields.songID: songID,
        SongsDBFields.albumID: albumID,
        SongsDBFields.albumOrSingle: albumOrSingle,
        SongsDBFields.songTitle: songTitle,
        SongsDBFields.year: year,
        SongsDBFields.singers: singers,
        SongsDBFields.musicDirector: musicDirector,
        SongsDBFields.lyricist: lyricist,
        SongsDBFields.artists: artists,
        SongsDBFields.resourceType: resourceType,
        SongsDBFields.resourceURL: resourceURL,
        SongsDBFields.thumbnailURL: thumbnailURL,
        SongsDBFields.primarySearchLabels: primarySearchLabels,
        SongsDBFields.secondarySearchLabels: secondarySearchLabels,
        SongsDBFields.likebilityIndex: likebilityIndex
      };
}
