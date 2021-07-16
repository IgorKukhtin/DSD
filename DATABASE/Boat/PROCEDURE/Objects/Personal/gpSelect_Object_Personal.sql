-- Function: gpSelect_Object_Personal (TVarChar)

DROP FUNCTION IF EXISTS gpSelect_Object_Personal (TDateTime, TDateTime, Boolean, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_Personal(
    IN inStartDate   TDateTime , --
    IN inEndDate     TDateTime , --
    IN inIsPeriod    Boolean   , --
    IN inIsShowAll   Boolean,    --
    IN inSession     TVarChar    -- сессия пользователя
)
RETURNS TABLE (Id Integer, BarCode_Personal TVarChar
             , MemberId Integer, MemberCode Integer, MemberName TVarChar
             , PositionId Integer, PositionCode Integer, PositionName TVarChar
             
             , UnitId Integer, UnitCode Integer, UnitName TVarChar
             , Comment TVarChar
             , InsertName TVarChar
             , InsertDate TDateTime
             , DateIn TDateTime, DateOut TDateTime, isDateOut Boolean
             , isMain Boolean, isOfficial Boolean
             , isErased Boolean
              )
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
   -- проверка прав пользователя на вызов процедуры
   -- vbUserId:= lpCheckRight(inSession, zc_Enum_Process_Select_Object_Personal());
   vbUserId:= lpGetUserBySession (inSession);

   -- Результат
   RETURN QUERY
     SELECT
           Object_Personal_View.PersonalId   AS Id
         , zfFormat_BarCode (zc_BarCodePref_Object(), Object_Personal_View.PersonalId) ::TVarChar AS BarCode_Personal
         , Object_Personal_View.MemberId     AS MemberId
         , Object_Personal_View.PersonalCode AS MemberCode
         , Object_Personal_View.PersonalName AS MemberName

         , Object_Personal_View.PositionId
         , Object_Personal_View.PositionCode
         , Object_Personal_View.PositionName

         , Object_Personal_View.UnitId
         , Object_Personal_View.UnitCode
         , Object_Personal_View.UnitName
         , ObjectString_Comment.ValueData    AS Comment

         , Object_Insert.ValueData           AS InsertName
         , ObjectDate_Insert.ValueData       AS InsertDate

         , Object_Personal_View.DateIn
         , Object_Personal_View.DateOut_user AS DateOut
         , Object_Personal_View.isDateOut
         , Object_Personal_View.isMain
         , Object_Personal_View.isOfficial
          
         , Object_Personal_View.isErased

     FROM Object_Personal_View
          LEFT JOIN ObjectString AS ObjectString_Comment
                                 ON ObjectString_Comment.ObjectId = Object_Personal_View.PersonalId
                                AND ObjectString_Comment.DescId = zc_ObjectString_Personal_Comment()  

          LEFT JOIN ObjectLink AS ObjectLink_Insert
                               ON ObjectLink_Insert.ObjectId = Object_Personal_View.PersonalId
                              AND ObjectLink_Insert.DescId = zc_ObjectLink_Protocol_Insert()
          LEFT JOIN Object AS Object_Insert ON Object_Insert.Id = ObjectLink_Insert.ChildObjectId 

          LEFT JOIN ObjectDate AS ObjectDate_Insert
                               ON ObjectDate_Insert.ObjectId = Object_Personal_View.PersonalId
                              AND ObjectDate_Insert.DescId = zc_ObjectDate_Protocol_Insert()

     WHERE (Object_Personal_View.isErased = FALSE
            OR (Object_Personal_View.isErased = TRUE AND inIsShowAll = TRUE OR inIsPeriod = TRUE)
           )
       AND (inIsPeriod = FALSE
            OR (inIsPeriod = TRUE AND ((Object_Personal_View.DateIn BETWEEN inStartDate AND inEndDate)
                                    OR (Object_Personal_View.DateOut BETWEEN inStartDate AND inEndDate)
                                    OR (Object_Personal_View.DateIn < inStartDate
                                    AND Object_Personal_View.DateOut > inEndDate)
                                      )
               )
           )
    ;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 16.06.21         *
 25.10.20         *
*/
-- тест
-- SELECT * FROM gpSelect_Object_Personal (inStartDate:= null, inEndDate:= null, inIsPeriod:= FALSE, inIsShowAll:= TRUE, inSession:= zfCalc_UserAdmin())