-- Function: gpSelect_Object_Maker()

DROP FUNCTION IF EXISTS gpSelect_Object_Maker(TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_Maker(
    IN inSession     TVarChar       -- ������ ������������
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar 
             , CountryId Integer, CountryCode Integer, CountryName TVarChar
             , ContactPersonId Integer, ContactPersonCode Integer, ContactPersonName TVarChar
             , Phone TVarChar, Mail TVarChar
             , SendPlan TDateTime
             , SendReal TDateTime
             , isReport1  Boolean
             , isReport2  Boolean
             , isReport3  Boolean
             , isReport4  Boolean
             , isErased   Boolean
             ) AS
$BODY$BEGIN
   -- �������� ���� ������������ �� ����� ���������
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Select_Object_Maker());

     RETURN QUERY  
       SELECT 
             Object_Maker.Id          AS Id
           , Object_Maker.ObjectCode  AS Code
           , Object_Maker.ValueData   AS Name
           
           , Object_Country.Id          AS CountryId
           , Object_Country.ObjectCode  AS CountryCode
           , Object_Country.ValueData   AS CountryName

           , Object_ContactPerson.Id          AS ContactPersonId
           , Object_ContactPerson.ObjectCode  AS ContactPersonCode
           , Object_ContactPerson.ValueData   AS ContactPersonName

           , ObjectString_Phone.ValueData     AS Phone
           , ObjectString_Mail.ValueData      AS Mail

           , COALESCE (ObjectDate_SendPlan.ValueData, NULL) :: TDateTime AS SendPlan
           , COALESCE (ObjectDate_SendReal.ValueData, NULL) :: TDateTime AS SendReal
           , COALESCE (ObjectBoolean_Maker_Report1.ValueData, FALSE) :: Boolean AS isReport1
           , COALESCE (ObjectBoolean_Maker_Report2.ValueData, FALSE) :: Boolean AS isReport2
           , COALESCE (ObjectBoolean_Maker_Report3.ValueData, FALSE) :: Boolean AS isReport3
           , COALESCE (ObjectBoolean_Maker_Report4.ValueData, FALSE) :: Boolean AS isReport4

           , Object_Maker.isErased AS isErased
           
       FROM Object AS Object_Maker
   
           LEFT JOIN ObjectLink AS ObjectLink_Maker_Country 
                                ON ObjectLink_Maker_Country.ObjectId = Object_Maker.Id 
                               AND ObjectLink_Maker_Country.DescId = zc_ObjectLink_Maker_Country()
           LEFT JOIN Object AS Object_Country ON Object_Country.Id = ObjectLink_Maker_Country.ChildObjectId              

           LEFT JOIN ObjectLink AS ObjectLink_Maker_ContactPerson 
                                ON ObjectLink_Maker_ContactPerson.ObjectId = Object_Maker.Id 
                               AND ObjectLink_Maker_ContactPerson.DescId = zc_ObjectLink_Maker_ContactPerson()
           LEFT JOIN Object AS Object_ContactPerson ON Object_ContactPerson.Id = ObjectLink_Maker_ContactPerson.ChildObjectId 

           LEFT JOIN ObjectDate AS ObjectDate_SendPlan
                                ON ObjectDate_SendPlan.ObjectId = Object_Maker.Id
                               AND ObjectDate_SendPlan.DescId = zc_ObjectDate_Maker_SendPlan()
           LEFT JOIN ObjectDate AS ObjectDate_SendReal
                                ON ObjectDate_SendReal.ObjectId = Object_Maker.Id
                               AND ObjectDate_SendReal.DescId = zc_ObjectDate_Maker_SendReal()

           LEFT JOIN ObjectBoolean AS ObjectBoolean_Maker_Report1
                                   ON ObjectBoolean_Maker_Report1.ObjectId = Object_Maker.Id
                                  AND ObjectBoolean_Maker_Report1.DescId = zc_ObjectBoolean_Maker_Report1()
           LEFT JOIN ObjectBoolean AS ObjectBoolean_Maker_Report2
                                   ON ObjectBoolean_Maker_Report2.ObjectId = Object_Maker.Id
                                  AND ObjectBoolean_Maker_Report2.DescId = zc_ObjectBoolean_Maker_Report2()
           LEFT JOIN ObjectBoolean AS ObjectBoolean_Maker_Report3
                                   ON ObjectBoolean_Maker_Report3.ObjectId = Object_Maker.Id
                                  AND ObjectBoolean_Maker_Report3.DescId = zc_ObjectBoolean_Maker_Report3()
           LEFT JOIN ObjectBoolean AS ObjectBoolean_Maker_Report4
                                   ON ObjectBoolean_Maker_Report4.ObjectId = Object_Maker.Id
                                  AND ObjectBoolean_Maker_Report4.DescId = zc_ObjectBoolean_Maker_Report4()

           LEFT JOIN ObjectString AS ObjectString_Phone
                                  ON ObjectString_Phone.ObjectId = Object_ContactPerson.Id 
                                 AND ObjectString_Phone.DescId = zc_ObjectString_ContactPerson_Phone()
           LEFT JOIN ObjectString AS ObjectString_Mail
                                  ON ObjectString_Mail.ObjectId = Object_ContactPerson.Id 
                                 AND ObjectString_Mail.DescId = zc_ObjectString_ContactPerson_Mail()

     WHERE Object_Maker.DescId = zc_Object_Maker();
  
END;
$BODY$

LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 16.01.19         *
 11.01.19         *
 11.02.14         *
*/

-- ����
-- SELECT * FROM gpSelect_Object_Maker('2')