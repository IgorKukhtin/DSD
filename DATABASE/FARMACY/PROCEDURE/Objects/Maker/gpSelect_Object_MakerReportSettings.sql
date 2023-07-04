-- Function: gpSelect_Object_MakerReportSettings()

DROP FUNCTION IF EXISTS gpSelect_Object_MakerReportSettings(TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_MakerReportSettings(
    IN inSession     TVarChar       -- ������ ������������
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar 
             , CountryId Integer, CountryCode Integer, CountryName TVarChar
             , ContactPersonId Integer, ContactPersonCode Integer, ContactPersonName TVarChar
             , JuridicalId Integer, JuridicalCode Integer, JuridicalName TVarChar
             , Phone TVarChar, Mail TVarChar
             , SendPlan TDateTime
             , SendReal TDateTime
             , SendLast TDateTime
             , AmountDay TFloat
             , AmountMonth TFloat
             , isReport1  Boolean
             , isReport2  Boolean
             , isReport3  Boolean
             , isReport4  Boolean
             , isReport5  Boolean
             , isReport6  Boolean
             , isReport7  Boolean
             , isReport8  Boolean
             , isQuarter  Boolean
             , is4Month   Boolean
             , isUnPlanned Boolean 
             , StartDateUnPlanned TDateTime
             , EndDateUnPlanned   TDateTime
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

           , Object_Juridical.Id          AS JuridicalId
           , Object_Juridical.ObjectCode  AS JuridicalCode
           , Object_Juridical.ValueData   AS JuridicalName

           , ObjectString_Phone.ValueData     AS Phone
           , ObjectString_Mail.ValueData      AS Mail

           , COALESCE (ObjectDate_SendPlan.ValueData, NULL) :: TDateTime AS SendPlan
           , COALESCE (ObjectDate_SendReal.ValueData, NULL) :: TDateTime AS SendReal

           , CASE WHEN COALESCE (ObjectFloat_Month.ValueData, 0) = 0 AND COALESCE (ObjectFloat_Day.ValueData, 0) = 0
                  THEN NULL
                  ELSE (ObjectDate_SendPlan.ValueData
                      + CASE WHEN COALESCE (ObjectFloat_Month.ValueData, 0) <> 0 THEN (ObjectFloat_Month.ValueData ::TVarChar || ' MONTH') :: INTERVAL ELSE '0 day' END
                      + CASE WHEN COALESCE (ObjectFloat_Day.ValueData, 0) <> 0   THEN (ObjectFloat_Day.ValueData  ::TVarChar  || ' DAY')   :: INTERVAL ELSE '0 day' END
                        )
             END :: TDateTime AS SendLast

           , COALESCE (ObjectFloat_Day.ValueData, 0)   :: TFloat AS AmountDay
           , COALESCE (ObjectFloat_Month.ValueData, 0) :: TFloat AS AmountMonth

           , COALESCE (ObjectBoolean_Maker_Report1.ValueData, FALSE) :: Boolean AS isReport1
           , COALESCE (ObjectBoolean_Maker_Report2.ValueData, FALSE) :: Boolean AS isReport2
           , COALESCE (ObjectBoolean_Maker_Report3.ValueData, FALSE) :: Boolean AS isReport3
           , COALESCE (ObjectBoolean_Maker_Report4.ValueData, FALSE) :: Boolean AS isReport4
           , COALESCE (ObjectBoolean_Maker_Report5.ValueData, FALSE) :: Boolean AS isReport5
           , COALESCE (ObjectBoolean_Maker_Report6.ValueData, FALSE) :: Boolean AS isReport6
           , COALESCE (ObjectBoolean_Maker_Report7.ValueData, FALSE) :: Boolean AS isReport7
           , COALESCE (ObjectBoolean_Maker_Report8.ValueData, FALSE) :: Boolean AS isReport8
           , COALESCE (ObjectBoolean_Maker_Quarter.ValueData, FALSE) :: Boolean AS isQuarter
           , COALESCE (ObjectBoolean_Maker_4Month.ValueData, FALSE) :: Boolean  AS is4Month

           , COALESCE (ObjectBoolean_Maker_UnPlanned.ValueData, FALSE) :: Boolean  AS isUnPlanned
           , ObjectDate_StartDateUnPlanned.ValueData                               AS StartDateUnPlanned
           , ObjectDate_EndDateUnPlanned.ValueData                                 AS EndDateUnPlanned

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

           LEFT JOIN ObjectLink AS ObjectLink_Maker_Juridical
                                ON ObjectLink_Maker_Juridical.ObjectId = Object_Maker.Id 
                               AND ObjectLink_Maker_Juridical.DescId = zc_ObjectLink_Maker_Juridical()
           LEFT JOIN Object AS Object_Juridical ON Object_Juridical.Id = ObjectLink_Maker_Juridical.ChildObjectId 

           LEFT JOIN ObjectDate AS ObjectDate_SendPlan
                                ON ObjectDate_SendPlan.ObjectId = Object_Maker.Id
                               AND ObjectDate_SendPlan.DescId = zc_ObjectDate_Maker_SendPlan()
           LEFT JOIN ObjectDate AS ObjectDate_SendReal
                                ON ObjectDate_SendReal.ObjectId = Object_Maker.Id
                               AND ObjectDate_SendReal.DescId = zc_ObjectDate_Maker_SendReal()

           LEFT JOIN ObjectDate AS ObjectDate_StartDateUnPlanned
                                ON ObjectDate_StartDateUnPlanned.ObjectId = Object_Maker.Id
                               AND ObjectDate_StartDateUnPlanned.DescId = zc_ObjectDate_Maker_StartDateUnPlanned()
           LEFT JOIN ObjectDate AS ObjectDate_EndDateUnPlanned
                                ON ObjectDate_EndDateUnPlanned.ObjectId = Object_Maker.Id
                               AND ObjectDate_EndDateUnPlanned.DescId = zc_ObjectDate_Maker_EndDateUnPlanned()

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
           LEFT JOIN ObjectBoolean AS ObjectBoolean_Maker_Report5
                                   ON ObjectBoolean_Maker_Report5.ObjectId = Object_Maker.Id
                                  AND ObjectBoolean_Maker_Report5.DescId = zc_ObjectBoolean_Maker_Report5()
           LEFT JOIN ObjectBoolean AS ObjectBoolean_Maker_Report6
                                   ON ObjectBoolean_Maker_Report6.ObjectId = Object_Maker.Id
                                  AND ObjectBoolean_Maker_Report6.DescId = zc_ObjectBoolean_Maker_Report6()
           LEFT JOIN ObjectBoolean AS ObjectBoolean_Maker_Report7
                                   ON ObjectBoolean_Maker_Report7.ObjectId = Object_Maker.Id
                                  AND ObjectBoolean_Maker_Report7.DescId = zc_ObjectBoolean_Maker_Report7()
           LEFT JOIN ObjectBoolean AS ObjectBoolean_Maker_Report8
                                   ON ObjectBoolean_Maker_Report8.ObjectId = Object_Maker.Id
                                  AND ObjectBoolean_Maker_Report8.DescId = zc_ObjectBoolean_Maker_Report8()
           LEFT JOIN ObjectBoolean AS ObjectBoolean_Maker_Quarter
                                   ON ObjectBoolean_Maker_Quarter.ObjectId = Object_Maker.Id
                                  AND ObjectBoolean_Maker_Quarter.DescId = zc_ObjectBoolean_Maker_Quarter()
           LEFT JOIN ObjectBoolean AS ObjectBoolean_Maker_4Month
                                   ON ObjectBoolean_Maker_4Month.ObjectId = Object_Maker.Id
                                  AND ObjectBoolean_Maker_4Month.DescId = zc_ObjectBoolean_Maker_4Month()

           LEFT JOIN ObjectBoolean AS ObjectBoolean_Maker_UnPlanned
                                   ON ObjectBoolean_Maker_UnPlanned.ObjectId = Object_Maker.Id
                                  AND ObjectBoolean_Maker_UnPlanned.DescId = zc_ObjectBoolean_Maker_UnPlanned()

           LEFT JOIN ObjectString AS ObjectString_Phone
                                  ON ObjectString_Phone.ObjectId = Object_ContactPerson.Id 
                                 AND ObjectString_Phone.DescId = zc_ObjectString_ContactPerson_Phone()
           LEFT JOIN ObjectString AS ObjectString_Mail
                                  ON ObjectString_Mail.ObjectId = Object_ContactPerson.Id 
                                 AND ObjectString_Mail.DescId = zc_ObjectString_ContactPerson_Mail()

           LEFT JOIN ObjectFloat AS ObjectFloat_Day
                                ON ObjectFloat_Day.ObjectId = Object_Maker.Id
                               AND ObjectFloat_Day.DescId = zc_ObjectFloat_Maker_Day()
           LEFT JOIN ObjectFloat AS ObjectFloat_Month
                                ON ObjectFloat_Month.ObjectId = Object_Maker.Id
                               AND ObjectFloat_Month.DescId = zc_ObjectFloat_Maker_Month()

     WHERE Object_Maker.DescId = zc_Object_Maker()
       AND COALESCE (ObjectString_Mail.ValueData, '') <> '';
  
END;
$BODY$

LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------

 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 09.09.21                                                       *
*/

-- ����
-- 
SELECT * FROM gpSelect_Object_MakerReportSettings('3')

