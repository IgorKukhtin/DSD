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
         
         , tmpMemberTransport.isErased

     FROM gpSelect_Object_Member(inIsShowAll, inSession) AS tmpMemberTransport
      
  
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
-- SELECT * FROM gpSelect_Object_MemberTransport_Choice (inSession := zfCalc_UserAdmin())
-- SELECT * FROM gpSelect_Object_MemberTransport_Choice (inSession := '9818')

