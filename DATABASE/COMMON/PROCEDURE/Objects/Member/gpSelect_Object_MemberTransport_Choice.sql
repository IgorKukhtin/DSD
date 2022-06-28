-- Function: gpSelect_Object_StoragePlace()

DROP FUNCTION IF EXISTS gpSelect_Object_MemberTransport_Choice (TDateTime, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_MemberTransport_Choice(
    IN inOperDate          TDateTime,
    IN inIsShowAll         Boolean  ,
    IN inSession           TVarChar     -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
             , INN TVarChar, DriverCertificate TVarChar, Comment TVarChar
             , isOfficial Boolean
             , InfoMoneyId Integer, InfoMoneyCode Integer, InfoMoneyName TVarChar, InfoMoneyName_all TVarChar
             , StartSummerDate TDateTime, EndSummerDate TDateTime
             , AmountFuel TFloat, Reparation TFloat, LimitMoney TFloat, LimitDistance TFloat
             , CarName TVarChar, CarModelName TVarChar
             , DescName TVarChar
             , isErased Boolean
              )
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpGetUserBySession (inSession);

     RETURN QUERY
     
     SELECT   
           tmpMemberTransport.Id         AS Id
         , tmpMemberTransport.Code
         , tmpMemberTransport.Name
         
         , tmpMemberTransport.INN
         , tmpMemberTransport.DriverCertificate
         , tmpMemberTransport.Comment

         , tmpMemberTransport.isOfficial
 
         , tmpMemberTransport.InfoMoneyId
         , tmpMemberTransport.InfoMoneyCode
         , tmpMemberTransport.InfoMoneyName
         , tmpMemberTransport.InfoMoneyName_all

         , tmpMemberTransport.StartSummerDate
         , tmpMemberTransport.EndSummerDate

         , CASE WHEN inOperDate > tmpMemberTransport.StartSummerDate AND inOperDate < tmpMemberTransport.EndSummerDate THEN tmpMemberTransport.SummerFuel ELSE tmpMemberTransport.WinterFuel END ::TFloat  AS AmountFuel
         
         , tmpMemberTransport.Reparation
         , tmpMemberTransport.LimitMoney
         , tmpMemberTransport.LimitDistance

         , tmpMemberTransport.CarName
         , tmpMemberTransport.CarModelName
         
         , ObjectDesc.ItemName     AS DescName 

         , tmpMemberTransport.isErased

     FROM gpSelect_Object_Member(inIsShowAll, inSession) AS tmpMemberTransport
       LEFT JOIN ObjectDesc ON ObjectDesc.Id = zc_Object_Member()

  UNION 
     SELECT   
           tmpFounder.Id         AS Id
         , tmpFounder.Code
         , tmpFounder.Name
         
         , CAST ('' AS TVarChar)  AS INN
         , CAST ('' AS TVarChar)  AS DriverCertificate
         , CAST ('' AS TVarChar)  AS Comment

         , FALSE AS isOfficial
 
         , tmpFounder.InfoMoneyId
         , tmpFounder.InfoMoneyCode
         , tmpFounder.InfoMoneyName
         , tmpFounder.InfoMoneyName_all

         , CAST (NULL AS TDateTime) AS StartSummerDate
         , CAST (NULL AS TDateTime) AS EndSummerDate

         , CAST (0 AS TFloat)       AS AmountFuel
         
         , CAST (0 AS TFloat)       AS Reparation
         , tmpFounder.LimitMoney
         , CAST (0 AS TFloat)       AS LimitDistance

         , CAST ('' AS TVarChar)    AS CarName
         , CAST ('' AS TVarChar)    AS CarModelName
         
         , ObjectDesc.ItemName     AS DescName 
         , tmpFounder.isErased

     FROM gpSelect_Object_Founder(inSession) AS tmpFounder
        LEFT JOIN ObjectDesc ON ObjectDesc.Id = zc_Object_Founder()
  
  UNION 
     SELECT   
           tmpObject.Id
         , tmpObject.ObjectCode
         , tmpObject.ValueData
         
         , CAST ('' AS TVarChar)  AS INN
         , CAST ('' AS TVarChar)  AS DriverCertificate
         , CAST ('' AS TVarChar)  AS Comment

         , FALSE AS isOfficial
 
         , CAST (0 AS Integer)      AS InfoMoneyId
         , CAST (0 AS Integer)      AS InfoMoneyCode
         , CAST ('' AS TVarChar)    AS InfoMoneyName
         , CAST ('' AS TVarChar)    AS InfoMoneyName_all

         , CAST (NULL AS TDateTime) AS StartSummerDate
         , CAST (NULL AS TDateTime) AS EndSummerDate

         , CAST (0 AS TFloat)       AS AmountFuel
         
         , CAST (0 AS TFloat)       AS Reparation
         , CAST (0 AS TFloat)       AS LimitMoney
         , CAST (0 AS TFloat)       AS LimitDistance

         , CAST ('' AS TVarChar)    AS CarName
         , CAST ('' AS TVarChar)    AS CarModelName
         
         , ObjectDesc.ItemName     AS DescName 
         , tmpObject.isErased

     FROM Object AS tmpObject
        LEFT JOIN ObjectDesc ON ObjectDesc.Id = tmpObject.DescId
     WHERE tmpObject.DescId = zc_Object_Unit()
       AND tmpObject.Id = 8289613 -- Склад ГСМ (бочки)
    ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;



/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 18.01.16         *
*/

-- тест
-- SELECT * FROM gpSelect_Object_MemberTransport_Choice (inOperDate:= CURRENT_DATE, inIsShowAll:= FALSE, inSession := zfCalc_UserAdmin())
