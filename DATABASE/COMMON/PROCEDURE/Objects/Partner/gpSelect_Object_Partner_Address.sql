-- Function: gpSelect_Object_Partner_Address()

DROP FUNCTION IF EXISTS gpSelect_Object_Partner_Address (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_Partner_Address(
    IN inJuridicalId       Integer  , 
    IN inSession           TVarChar   -- ������ ������������
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar, 
               ShortName TVarChar,
               Address TVarChar, HouseNumber TVarChar, CaseNumber TVarChar, RoomNumber TVarChar,
               StreetId Integer, StreetName TVarChar,
               PostalCode TVarChar, ProvinceCityName TVarChar, 
               CityName TVarChar, CityKindName TVarChar, CityKindId Integer,
               RegionName TVarChar, ProvinceName TVarChar,
               StreetKindName TVarChar, StreetKindId Integer,
               JuridicalId Integer, JuridicalName TVarChar, 
               Order_ContactPersonKindId Integer, Order_ContactPersonKindName TVarChar, Order_Name TVarChar, Order_Mail TVarChar, Order_Phone TVarChar,
               Doc_ContactPersonKindId Integer, Doc_ContactPersonKindName TVarChar, Doc_Name TVarChar, Doc_Mail TVarChar, Doc_Phone TVarChar,
               Act_ContactPersonKindId Integer, Act_ContactPersonKindName TVarChar, Act_Name TVarChar, Act_Mail TVarChar, Act_Phone TVarChar,
              --OKPO TVarChar,
               isErased Boolean
              )
AS
$BODY$
BEGIN

   -- �������� ���� ������������ �� ����� ���������
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Select_Object_Partner());

   RETURN QUERY 

   WITH tmpContactPerson as ( SELECT 
                                     Object_ContactPerson.ValueData   AS Name
                                   , ObjectString_Phone.ValueData     AS Phone
                                   , ObjectString_Mail.ValueData      AS Mail
           
                                   , ContactPerson_Object.Id          AS PartnerId
                                   , ObjectLink_ContactPerson_ContactPersonKind.ChildObjectId AS ContactPersonKindId
 
                              FROM Object AS Object_ContactPerson
       
                                    LEFT JOIN ObjectString AS ObjectString_Phone
                                                           ON ObjectString_Phone.ObjectId = Object_ContactPerson.Id 
                                                          AND ObjectString_Phone.DescId = zc_ObjectString_ContactPerson_Phone()
                                    LEFT JOIN ObjectString AS ObjectString_Mail
                                                           ON ObjectString_Mail.ObjectId = Object_ContactPerson.Id 
                                                          AND ObjectString_Mail.DescId = zc_ObjectString_ContactPerson_Mail()
            
                                    LEFT JOIN ObjectLink AS ContactPerson_ContactPerson_Object
                                                         ON ContactPerson_ContactPerson_Object.ObjectId = Object_ContactPerson.Id
                                                        AND ContactPerson_ContactPerson_Object.DescId = zc_ObjectLink_ContactPerson_Object()
                                     JOIN Object AS ContactPerson_Object ON ContactPerson_Object.Id = ContactPerson_ContactPerson_Object.ChildObjectId
                                                                        AND ContactPerson_Object.DescId = zc_Object_Partner()
                                    
                                     JOIN ObjectLink AS ObjectLink_ContactPerson_ContactPersonKind
                                                     ON ObjectLink_ContactPerson_ContactPersonKind.ObjectId = Object_ContactPerson.Id
                                                    AND ObjectLink_ContactPerson_ContactPersonKind.DescId = zc_ObjectLink_ContactPerson_ContactPersonKind()
           
                              WHERE Object_ContactPerson.DescId = zc_Object_ContactPerson()
                            )

     SELECT 
           Object_Partner.Id               AS Id
         , Object_Partner.ObjectCode       AS Code
         , Object_Partner.ValueData        AS Name

         , ObjectString_ShortName.ValueData   AS ShortName
        
         , ObjectString_Address.ValueData     AS Address
         , ObjectString_HouseNumber.ValueData AS HouseNumber
         , ObjectString_CaseNumber.ValueData  AS CaseNumber
         , ObjectString_RoomNumber.ValueData  AS RoomNumber

         , Object_Street_View.Id              AS StreetId 
         , Object_Street_View.Name            AS StreetName 
         , Object_Street_View.PostalCode      AS PostalCode 
         , Object_Street_View.ProvinceCityName  AS ProvinceCityName
         , Object_Street_View.CityName        AS CityName 
         , Object_CityKind.ValueData          AS CityKindName
         , Object_CityKind.Id                 AS CityKindId
         , Object_Region.ValueData            AS RegionName
         , Object_Province.ValueData          AS ProvinceName
         , Object_Street_View.StreetKindName  AS StreetKindName
         , Object_Street_View.StreetKindId    AS StreetKindId
          
         , Object_Juridical.Id           AS JuridicalId
         , Object_Juridical.ValueData    AS JuridicalName

         , zc_Enum_ContactPersonKind_CreateOrder()  AS Order_ContactPersonKindId
         , lfGet_Object_ValueData (zc_Enum_ContactPersonKind_CreateOrder()) AS Order_ContactPersonKindName 
         , tmpContactPerson_Order.Name   AS Order_Name
         , tmpContactPerson_Order.Mail   AS Order_Mail
         , tmpContactPerson_Order.Phone  AS Order_Phone

         , zc_Enum_ContactPersonKind_CheckDocument()  AS Doc_ContactPersonKindId
         , lfGet_Object_ValueData (zc_Enum_ContactPersonKind_CheckDocument()) AS Doc_ContactPersonKindName
         , tmpContactPerson_Doc.Name    AS Doc_Name
         , tmpContactPerson_Doc.Mail    AS Doc_Mail
         , tmpContactPerson_Doc.Phone   AS Doc_Phone

         , zc_Enum_ContactPersonKind_AktSverki()  AS Act_ContactPersonKindId
         , lfGet_Object_ValueData (zc_Enum_ContactPersonKind_AktSverki()) AS Act_ContactPersonKindName
         , tmpContactPerson_Act.Name    AS Act_Name
         , tmpContactPerson_Act.Mail    AS Act_Mail
         , tmpContactPerson_Act.Phone   AS Act_Phone


       --  , ObjectHistory_JuridicalDetails_View.OKPO

         , Object_Partner.isErased   AS isErased
         
     FROM Object AS Object_Partner
   
         LEFT JOIN ObjectString AS ObjectString_Address
                                ON ObjectString_Address.ObjectId = Object_Partner.Id
                               AND ObjectString_Address.DescId = zc_ObjectString_Partner_Address()

         LEFT JOIN ObjectString AS ObjectString_HouseNumber
                                ON ObjectString_HouseNumber.ObjectId = Object_Partner.Id
                               AND ObjectString_HouseNumber.DescId = zc_ObjectString_Partner_HouseNumber()

         LEFT JOIN ObjectString AS ObjectString_ShortName
                                ON ObjectString_ShortName.ObjectId = Object_Partner.Id
                               AND ObjectString_ShortName.DescId = zc_ObjectString_Partner_ShortName()

         LEFT JOIN ObjectString AS ObjectString_CaseNumber
                                ON ObjectString_CaseNumber.ObjectId = Object_Partner.Id
                               AND ObjectString_CaseNumber.DescId = zc_ObjectString_Partner_CaseNumber()

         LEFT JOIN ObjectString AS ObjectString_RoomNumber
                                ON ObjectString_RoomNumber.ObjectId = Object_Partner.Id
                               AND ObjectString_RoomNumber.DescId = zc_ObjectString_Partner_RoomNumber()

         LEFT JOIN ObjectLink AS ObjectLink_Partner_Street
                              ON ObjectLink_Partner_Street.ObjectId = Object_Partner.Id 
                             AND ObjectLink_Partner_Street.DescId = zc_ObjectLink_Partner_Street()
         LEFT JOIN Object_Street_View ON Object_Street_View.Id = ObjectLink_Partner_Street.ChildObjectId

         LEFT JOIN ObjectLink AS ObjectLink_Partner_Juridical
                              ON ObjectLink_Partner_Juridical.ObjectId = Object_Partner.Id 
                             AND ObjectLink_Partner_Juridical.DescId = zc_ObjectLink_Partner_Juridical()
         LEFT JOIN Object AS Object_Juridical ON Object_Juridical.Id = ObjectLink_Partner_Juridical.ChildObjectId

         LEFT JOIN ObjectLink AS ObjectLink_City_CityKind                                          -- �� �����
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

        LEFT JOIN tmpContactPerson AS tmpContactPerson_Order on tmpContactPerson_Order.PartnerId = Object_Partner.Id  AND  tmpContactPerson_Order.ContactPersonKindId = 153272    --"������������ �������"
        LEFT JOIN tmpContactPerson AS tmpContactPerson_Doc on tmpContactPerson_Doc.PartnerId = Object_Partner.Id  AND  tmpContactPerson_Doc.ContactPersonKindId = 153273    --"�������� ����������"
        LEFT JOIN tmpContactPerson AS tmpContactPerson_Act on tmpContactPerson_Act.PartnerId = Object_Partner.Id  AND  tmpContactPerson_Act.ContactPersonKindId = 153274    --"���� ������ � ���������� �����" 
        
    WHERE Object_Partner.DescId = zc_Object_Partner() AND (inJuridicalId = 0 OR inJuridicalId = ObjectLink_Partner_Juridical.ChildObjectId);
  
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Object_Partner_Address (integer, TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 17.10.14         *
 19.06.14         * 
*/

-- ����
-- SELECT * FROM gpSelect_Object_Partner_Address (0,'2')