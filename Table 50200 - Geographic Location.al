table 50200 "Geographic Location"
{

    fields
    {
        field(1;id;Integer)
        {
            CaptionML=ENU='ID';
        }
        field(2;name;text[250])
        {
            CaptionML=ENU='Name';
        }
        field(3;country;text[250])
        {
            CaptionML=ENU='Country';
        }
        field(5;lat;Decimal)
        {
            CaptionML=ENU='Latitude';
            DecimalPlaces=7;
        }
        field(6;lng;Decimal)
        {
            CaptionML=ENU='Longitude';
            DecimalPlaces=7;
        }
        field(7;administrative_area_level_1;Text[250])
        {
            CaptionML=ENU='Administrative Area Level 1';
        }
        field(8;postal_code_prefix;Decimal)
        {
            CaptionML=ENU='Postal Code Prefix';
            DecimalPlaces=0;
        }
        field(9;id_pk;Integer)
        {
            CaptionML=ENU='ID';
            AutoIncrement=true;
        }
    }

    keys
    {
        key(PK;id)
        {
            Clustered = true;
        }
        key(SK;id_pk)
        {
        }
    }
}