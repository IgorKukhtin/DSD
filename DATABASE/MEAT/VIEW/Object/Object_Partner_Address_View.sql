-- View: Object_Partner_Address_View

-- DROP VIEW IF EXISTS Object_Partner_Address_View;

CREATE OR REPLACE VIEW Object_Partner_Address_View AS
  SELECT Object_Partner.Id                           AS PartnerId
       , Object_Partner.ObjectCode                   AS PartnerCode
       , Object_Partner.ValueData                    AS PartnerName

       , ObjectLink_Partner_Area.ChildObjectId       AS AreaId
       , Object_Area.ValueData                       AS AreaName
       , ObjectLink_Partner_PartnerTag.ChildObjectId AS PartnerTagId
       , Object_PartnerTag.ValueData                 AS PartnerTagName
       , ObjectLink_City_Region.ChildObjectId        AS RegionId
       , Object_Region.ValueData                     AS RegionName
       , ObjectLink_City_Province.ChildObjectId      AS ProvinceId
       , Object_Province.ValueData                   AS ProvinceName
       , ObjectLink_City_CityKind.ChildObjectId      AS CityKindId
       , Object_CityKind.ValueData                   AS CityKindName
       , Object_Street_View.CityId                   AS CityId
       , Object_Street_View.CityName                 AS CityName
       , Object_Street_View.ProvinceCityId           AS ProvinceCityId
       , Object_Street_View.ProvinceCityName         AS ProvinceCityName
       , Object_Street_View.StreetKindId             AS StreetKindId
       , Object_Street_View.StreetKindName           AS StreetKindName
       , ObjectLink_Partner_Street.ChildObjectId     AS StreetId
       , Object_Street_View.Name                     AS StreetName

       , Object_Partner.isErased                     AS isErased
  FROM Object AS Object_Partner
         LEFT JOIN ObjectLink AS ObjectLink_Partner_Area
                              ON ObjectLink_Partner_Area.ObjectId = Object_Partner.Id 
                             AND ObjectLink_Partner_Area.DescId = zc_ObjectLink_Partner_Area()
         LEFT JOIN Object AS Object_Area ON Object_Area.Id = ObjectLink_Partner_Area.ChildObjectId

         LEFT JOIN ObjectLink AS ObjectLink_Partner_PartnerTag
                              ON ObjectLink_Partner_PartnerTag.ObjectId = Object_Partner.Id 
                             AND ObjectLink_Partner_PartnerTag.DescId = zc_ObjectLink_Partner_PartnerTag()
         LEFT JOIN Object AS Object_PartnerTag ON Object_PartnerTag.Id = ObjectLink_Partner_PartnerTag.ChildObjectId

         LEFT JOIN ObjectLink AS ObjectLink_Partner_Street
                              ON ObjectLink_Partner_Street.ObjectId = Object_Partner.Id 
                             AND ObjectLink_Partner_Street.DescId = zc_ObjectLink_Partner_Street()
         LEFT JOIN Object_Street_View ON Object_Street_View.Id = ObjectLink_Partner_Street.ChildObjectId

         LEFT JOIN ObjectLink AS ObjectLink_City_CityKind
                              ON ObjectLink_City_CityKind.ObjectId = Object_Street_View.CityId
                             AND ObjectLink_City_CityKind.DescId = zc_ObjectLink_City_CityKind()
         LEFT JOIN Object AS Object_CityKind ON Object_CityKind.Id = ObjectLink_City_CityKind.ChildObjectId

         LEFT JOIN ObjectLink AS ObjectLink_City_Region 
                             ON ObjectLink_City_Region.ObjectId = Object_Street_View.CityId
                            AND ObjectLink_City_Region.DescId = zc_ObjectLink_City_Region()
         LEFT JOIN Object AS Object_Region ON Object_Region.Id = ObjectLink_City_Region.ChildObjectId

         LEFT JOIN ObjectLink AS ObjectLink_City_Province
                              ON ObjectLink_City_Province.ObjectId = Object_Street_View.CityId
                             AND ObjectLink_City_Province.DescId = zc_ObjectLink_City_Province()
         LEFT JOIN Object AS Object_Province ON Object_Province.Id = ObjectLink_City_Province.ChildObjectId


  WHERE Object_Partner.DescId = zc_Object_Partner();

ALTER TABLE Object_Partner_Address_View  OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 »—“Œ–»ﬂ –¿«–¿¡Œ“ »: ƒ¿“¿, ¿¬“Œ–
               ‘ÂÎÓÌ˛Í ».¬.    ÛıÚËÌ ».¬.    ÎËÏÂÌÚ¸Â‚  .».   Ã‡Ì¸ÍÓ ƒ.¿.
 24.11.14                         *
 19.11.14                                        *
*/

-- ÚÂÒÚ
-- SELECT * FROM Object_Partner_Address_View