codeunit 50200 GetAPIData
{
    var
        Location : Record "Geographic Location";
    procedure Get(City:Text);
    var
        HttpClient : HttpClient;
        ResponseMessage : HttpResponseMessage;
        JsonToken : JsonToken;
        JsonValue : JsonValue;
        JsonObject : JsonObject;
        JsonArray : JsonArray;
        JsonText : text;
        next_id : Integer;
        url : Text[250];
    begin    

        // Web service call
        url := 'https://maps.googleapis.com/maps/api/geocode/json?address=' + City;
        //if not HttpClient.Get('https://maps.googleapis.com/maps/api/geocode/json?address=London',
        if not HttpClient.Get(url, ResponseMessage)
        then
            Error('The call to the web service failed.');

        if not ResponseMessage.IsSuccessStatusCode then
            error('The web service returned an error message:\\' +
                  'Status code: %1\' +
                  'Description: %2',
                  ResponseMessage.HttpStatusCode,
                  ResponseMessage.ReasonPhrase);
        
        ResponseMessage.Content.ReadAs(JsonText);

        if not JsonToken.ReadFrom(JsonText) then
            Error('Invalid response, expected an JSON token as root object');

        JsonObject := JsonToken.AsObject;
        JsonObject.SelectToken('results', JsonToken);
        JsonArray := JsonToken.AsArray;
        
        JsonArray.Get(0,JsonToken); //only one main array element 
        JsonObject := JsonToken.AsObject;


        if Location.FindLast then
            next_id := Location.id + 1
        else
            next_id := 1;

        Location.Reset;
        Location.Init;
        Location.id := next_id;
        HandleAddressComponentsData(JsonObject);
        HandleGeometryData(JsonObject);
        Location.Insert;
    end;

    procedure HandleAddressComponentsData(JsonObject:JsonObject);
    var
        JsonToken : JsonToken;
        JsonValue : JsonValue;
        JsonArray : JsonArray;
        JsonText : text;
    begin
        JsonObject.SelectToken('address_components', JsonToken);
        JsonArray := JsonToken.AsArray;
        
        JsonArray.Get(0,JsonToken); //basic info - name
        JsonObject := JsonToken.AsObject;
        Location.name := GetJsonToken(JsonObject, 'long_name').AsValue.AsText;

        JsonArray.Get(2,JsonToken); //administrative area
        JsonObject := JsonToken.AsObject;
        Location.administrative_area_level_1 := GetJsonToken(JsonObject, 'long_name').AsValue.AsText;

        JsonArray.Get(3,JsonToken); //country
        JsonObject := JsonToken.AsObject;
        Location.country := GetJsonToken(JsonObject, 'long_name').AsValue.AsText;

        JsonArray.Get(4,JsonToken); //postal code prefix
        JsonObject := JsonToken.AsObject;
        Location.postal_code_prefix := GetJsonToken(JsonObject, 'long_name').AsValue.AsDecimal;
    end;

    procedure HandleGeometryData(JsonObject:JsonObject);
    var
        JsonToken : JsonToken;
        JsonValue : JsonValue;
        JsonArray : JsonArray;
        JsonText : text;
    begin
        JsonObject.SelectToken('geometry', JsonToken);
        JsonObject := JsonToken.AsObject;
        Location.lat := SelectJsonToken(JsonObject, '$.location.lat').AsValue.AsDecimal;
        Location.lng := SelectJsonToken(JsonObject, '$.location.lng').AsValue.AsDecimal;
    end;

    procedure GetJsonToken(JsonObject:JsonObject;TokenKey:text)JsonToken:JsonToken;
    begin
        if not JsonObject.Get(TokenKey,JsonToken) then
            Error('Could not find a token with key %1',TokenKey);
    end;
    procedure SelectJsonToken(JsonObject:JsonObject;Path:text)JsonToken:JsonToken;
    begin
        if not JsonObject.SelectToken(Path,JsonToken) then
            Error('Could not find a token with path %1',Path);
    end;
}