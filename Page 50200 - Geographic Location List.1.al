page 50200 "Geographic Location List"
{
    PageType = List;
    SourceTable = "Geographic Location";
    CaptionML=ENU='Geographic Location';
    Editable = true;
    UsageCategory = Documents;
    SourceTableView=order(descending);

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field(id;id) {}
                field(name;name) {}
                field(country;country) {}
                field(administrative_area_level_1;administrative_area_level_1){}
                field(lat;lat) {}
                field(lng;lng) {}
                field(postal_code_prefix;postal_code_prefix){}
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(GetAPIDataCity)
            {
                CaptionML=ENU='Get API Data - Specific City Information';
                Promoted=true;
                PromotedCategory=Process;
                Image=GetLines;
                trigger OnAction();
                begin
                    Report.Run(Report::"Geographic Location Report");
                    CurrPage.Update;
                    if FindFirst then;
                end;
            }
        }
    }
}