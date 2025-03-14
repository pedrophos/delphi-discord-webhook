unit WebhookDiscord.Types;

interface
uses
  System.Generics.Collections, DateUtils, Rest.Json.Types;

type
  TAuthor = class
  private
    [JsonName('name')]
    FName: string;
    [JsonName('url')]
    FUrl: string;
    [JsonName('icon_url')]
    FIconUrl: string;
  public
    property Name: string read FName write FName;
    property Url: string read FUrl write FUrl;
    property IconUrl: string read FIconUrl write FIconUrl;
  end;

  TField = class
  private
    [JsonName('name')]
    FName: string;
    [JsonName('value')]
    FValue: string;
    [JsonName('inline')]
    FInline: Boolean;
  public
    property Name: string read FName write FName;
    property Value: string read FValue write FValue;
    property In_line: Boolean read FInline write FInline;
  end;

  TThumbnail = class
  private
    [JsonName('url')]
    FUrl: string;
  public
    property Url: string read FUrl write FUrl;
  end;

  TImage = class
  private
    [JsonName('url')]
    FUrl: string;
  public
    property Url: string read FUrl write FUrl;
  end;

  TFooter = class
  private
    [JsonName('text')]
    FText: string;
    [JsonName('icon_url')]
    FIconUrl: string;
  public
    property Text: string read FText write FText;
    property IconUrl: string read FIconUrl write FIconUrl;
  end;

  TEmbed = class
  private
    [JsonName('author')]
    FAuthor: TAuthor;
    [JsonName('title')]
    FTitle: string;
    [JsonName('url')]
    FUrl: string;
    [JsonName('description')]
    FDescription: string;
    [JsonName('color')]
    FColor: Integer;
    [JsonName('fields')]
    FFields: TArray<TField>;
    [JsonName('thumbnail')]
    FThumbnail: TThumbnail;
    [JsonName('image')]
    FImage: TImage;
    [JsonName('footer')]
    FFooter: TFooter;
    [JsonName('timestamp')]
    FTimestamp: string;
    function getTimestamp: TDateTime;
    procedure setTimeStamp(const Value: TDateTime);
  public
    constructor create;
    property Author: TAuthor read FAuthor write FAuthor;
    property Title: string read FTitle write FTitle;
    property Url: string read FUrl write FUrl;
    property Description: string read FDescription write FDescription;
    property Color: Integer read FColor write FColor;
    property Fields: TArray<TField> read FFields write FFields;
    property Thumbnail: TThumbnail read FThumbnail write FThumbnail;
    property Image: TImage read FImage write FImage;
    property Footer: TFooter read FFooter write FFooter;
    property TimeStamp: TDateTime read getTimestamp write setTimeStamp;
  end;

  TWebhookMessage = class
  private
    [JsonName('username')]
    FUsername: string;
    [JsonName('avatar_url')]
    FAvatarUrl: string;
    [JsonName('content')]
    FContent: string;
    [JsonName('embeds')]
    FEmbeds: TArray<TEmbed>;
    [JsonName('tts')]
    FTts: Boolean;
  public
    constructor Create;
    property Username: string read FUsername write FUsername;
    property AvatarUrl: string read FAvatarUrl write FAvatarUrl;
    property Content: string read FContent write FContent;
    property Embeds: TArray<TEmbed> read FEmbeds write FEmbeds;
    property Tts: boolean read FTts write FTts;
  end;


implementation
 uses
  System.SysUtils;

{ TEmbed }

constructor TEmbed.create;
begin
  FAuthor := TAuthor.Create;
  FFooter := TFooter.Create;
end;

function TEmbed.getTimestamp: TDateTime;
begin
  Result := ISO8601ToDate(FTimestamp);
end;

procedure TEmbed.setTimeStamp(const Value: TDateTime);
begin
  FTimestamp := FormatDateTime('yyyy-mm-dd"T"hh:nn:ss"Z"', TTimeZone.Local.ToUniversalTime(Value));
end;

{ TWebhookMessage }

constructor TWebhookMessage.Create;
begin
  SetLength(FEmbeds,1);
end;

end.
