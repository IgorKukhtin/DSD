-- Function: gpGet_Object_Member (Integer, TVarChar)

DROP FUNCTION IF EXISTS gpGet_Object_Member (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_Member(
    IN inId          Integer,        -- Физические лица 
    IN inSession     TVarChar        -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
             , INN TVarChar, DriverCertificate TVarChar, Comment TVarChar
             , EMail TVarChar, Phone TVarChar, Address TVarChar
             , EMailSign Tblob, Photo Tblob
             , EducationId Integer, EducationCode Integer, EducationName TVarChar
             , isManagerPharmacy Boolean
             , PositionID Integer, PositionName TVarChar
             , UnitID Integer, UnitName TVarChar, isNotSchedule Boolean, isReleasedMarketingPlan Boolean
             , isOfficial Boolean) AS
$BODY$
BEGIN

     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Get_Object_Member());

   IF COALESCE (inId, 0) = 0
   THEN
       RETURN QUERY 
       SELECT
             CAST (0 as Integer)    AS Id
           , lfGet_ObjectCode(0, zc_Object_Member()) AS Code
           , CAST ('' as TVarChar)  AS NAME
           
           , CAST ('' as TVarChar)  AS INN
           , CAST ('' as TVarChar)  AS DriverCertificate
           , CAST ('' as TVarChar)  AS Comment

           , CAST ('' as TVarChar)  AS EMail
           , CAST ('' as TVarChar)  AS Phone
           , CAST ('' as TVarChar)  AS Address

           , CAST ('' as TBlob)     AS EMailSign
           , CAST ('' as TBlob)     AS Photo

           , CAST (0 as Integer)    AS EducationId
           , CAST (0 as Integer)    AS EducationCode
           , CAST ('' as TVarChar)  AS EducationName   
  
           , FALSE                  AS ManagerPharmacy
           , CAST (0 as Integer)    AS PositionId
           , CAST ('' as TVarChar)  AS PositionName   

           , CAST (0 as Integer)    AS UnitID
           , CAST ('' as TVarChar)  AS UnitName
           , FALSE                  AS isNotSchedule
           , FALSE                  AS isReleasedMarketingPlan

           , FALSE AS isOfficial;
   ELSE
       RETURN QUERY 
     SELECT 
           Object_Member.Id         AS Id
         , Object_Member.ObjectCode AS Code
         , Object_Member.ValueData  AS Name
         
         , ObjectString_INN.ValueData               AS INN
         , ObjectString_DriverCertificate.ValueData AS DriverCertificate
         , ObjectString_Comment.ValueData           AS Comment


         , ObjectString_EMail.ValueData             AS EMail
         , ObjectString_Phone.ValueData             AS Phone
         , ObjectString_Address.ValueData           AS Address

         , ObjectBlob_EMailSign.ValueData           AS EMailSign
         , ObjectBlob_Photo.ValueData               AS Photo
 
         , Object_Education.Id                      AS EducationId
         , Object_Education.ObjectCode              AS EducationCode
         , Object_Education.ValueData               AS EducationName

         , COALESCE (ObjectBoolean_ManagerPharmacy.ValueData, False)  AS isManagerPharmacy
         , Object_Position.Id                       AS PositionID
         , Object_Position.ValueData                AS PositionName

         , Object_Unit.Id                           AS UnitID
         , Object_Unit.ValueData                    AS UnitName
         , COALESCE (ObjectBoolean_NotSchedule.ValueData, False)  AS isNotSchedule
         , COALESCE (ObjectBoolean_ReleasedMarketingPlan.ValueData, False)  AS isReleasedMarketingPlan

         , COALESCE (ObjectBoolean_Official.ValueData, False)     AS isOfficial

     FROM Object AS Object_Member
          LEFT JOIN ObjectBoolean AS ObjectBoolean_Official
                                  ON ObjectBoolean_Official.ObjectId = Object_Member.Id
                                 AND ObjectBoolean_Official.DescId = zc_ObjectBoolean_Member_Official()
          LEFT JOIN ObjectString AS ObjectString_INN ON ObjectString_INN.ObjectId = Object_Member.Id 
                AND ObjectString_INN.DescId = zc_ObjectString_Member_INN()
 
          LEFT JOIN ObjectString AS ObjectString_DriverCertificate ON ObjectString_DriverCertificate.ObjectId = Object_Member.Id 
                AND ObjectString_DriverCertificate.DescId = zc_ObjectString_Member_DriverCertificate()

          LEFT JOIN ObjectString AS ObjectString_Comment ON ObjectString_Comment.ObjectId = Object_Member.Id 
                AND ObjectString_Comment.DescId = zc_ObjectString_Member_Comment()

          LEFT JOIN ObjectString AS ObjectString_EMail
                                 ON ObjectString_EMail.ObjectId = Object_Member.Id 
                                AND ObjectString_EMail.DescId = zc_ObjectString_Member_EMail()
          LEFT JOIN ObjectString AS ObjectString_Phone
                                 ON ObjectString_Phone.ObjectId = Object_Member.Id 
                                AND ObjectString_Phone.DescId = zc_ObjectString_Member_Phone()
          LEFT JOIN ObjectString AS ObjectString_Address
                                 ON ObjectString_Address.ObjectId = Object_Member.Id 
                                AND ObjectString_Address.DescId = zc_ObjectString_Member_Address()

         LEFT JOIN ObjectBlob AS ObjectBlob_EMailSign
                              ON ObjectBlob_EMailSign.ObjectId = Object_Member.Id
                             AND ObjectBlob_EMailSign.DescId = zc_ObjectBlob_Member_EMailSign()
         
         LEFT JOIN ObjectBlob AS ObjectBlob_Photo
                              ON ObjectBlob_Photo.ObjectId = Object_Member.Id
                             AND ObjectBlob_Photo.DescId = zc_ObjectBlob_Member_Photo()

         LEFT JOIN ObjectLink AS ObjectLink_Member_Education
                              ON ObjectLink_Member_Education.ObjectId = Object_Member.Id
                             AND ObjectLink_Member_Education.DescId = zc_ObjectLink_Member_Education()
         LEFT JOIN Object AS Object_Education ON Object_Education.Id = ObjectLink_Member_Education.ChildObjectId
    
         LEFT JOIN ObjectBoolean AS ObjectBoolean_ManagerPharmacy
                                 ON ObjectBoolean_ManagerPharmacy.ObjectId = Object_Member.Id
                                AND ObjectBoolean_ManagerPharmacy.DescId = zc_ObjectBoolean_Member_ManagerPharmacy()

         LEFT JOIN ObjectLink AS ObjectLink_Member_Position
                              ON ObjectLink_Member_Position.ObjectId = Object_Member.Id
                             AND ObjectLink_Member_Position.DescId = zc_ObjectLink_Member_Position()
         LEFT JOIN Object AS Object_Position ON Object_Position.Id = ObjectLink_Member_Position.ChildObjectId

         LEFT JOIN ObjectLink AS ObjectLink_Member_Unit
                              ON ObjectLink_Member_Unit.ObjectId = Object_Member.Id
                             AND ObjectLink_Member_Unit.DescId = zc_ObjectLink_Member_Unit()
         LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = ObjectLink_Member_Unit.ChildObjectId

         LEFT JOIN ObjectBoolean AS ObjectBoolean_NotSchedule
                                 ON ObjectBoolean_NotSchedule.ObjectId = Object_Member.Id
                                AND ObjectBoolean_NotSchedule.DescId = zc_ObjectBoolean_Member_NotSchedule()

         LEFT JOIN ObjectBoolean AS ObjectBoolean_ReleasedMarketingPlan
                                 ON ObjectBoolean_ReleasedMarketingPlan.ObjectId = Object_Member.Id
                                AND ObjectBoolean_ReleasedMarketingPlan.DescId = zc_ObjectBoolean_Member_ReleasedMarketingPlan()

     WHERE Object_Member.Id = inId;
     
   END IF;
   
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 16.09.19                                                       *
 02.09.19                                                       *
 25.08.19                                                       *
 25.01.11         * 
*/

-- тест
-- SELECT * FROM gpGet_Object_Member (1, '2')

select * from gpGet_Object_Member(inId := 19506592 ,  inSession := '3');