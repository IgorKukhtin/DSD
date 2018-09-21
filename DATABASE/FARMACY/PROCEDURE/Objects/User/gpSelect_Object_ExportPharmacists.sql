-- Function: gpSelect_Object_ExportPharmacists (TVarChar)

DROP FUNCTION IF EXISTS gpSelect_Object_ExportPharmacists (TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_ExportPharmacists(
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (RowData TBlob)
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN

   CREATE EXTENSION IF NOT EXISTS pgcrypto;
   CREATE TEMP TABLE _Result(RowData TBlob) ON COMMIT DROP;
    
    --Шапка
   INSERT INTO _Result(RowData) Values ('<?xml version="1.0" encoding="utf-8"?>');
   INSERT INTO _Result(RowData) Values ('<Offers>');
    --Тело

   WITH tmpPersonal AS (SELECT View_Personal.MemberId
                             , MAX (View_Personal.UnitId) AS UnitId
                             , MAX (View_Personal.PositionId) AS PositionId
                        FROM Object_Personal_View AS View_Personal
                        WHERE View_Personal.isErased = FALSE
                        GROUP BY View_Personal.MemberId
                       ),
        tmpResult AS (SELECT 
                             MovementItem.ObjectId         AS UserID
                           , MovementItem.Amount           AS Result       
                           , MovementItemDate.ValueData    AS DateTimeTest                              
                      FROM Movement 
                           INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id 
                                                  AND MovementItem.DescId = zc_MI_Master()
                           INNER JOIN MovementItemDate ON MovementItemDate.MovementItemId = MovementItem.Id
                                                      AND MovementItemDate.DescId = zc_MIDate_TestingUser()
                      WHERE Movement.DescId = zc_Movement_TestingUser() 
                        AND Movement.OperDate = date_trunc('month', CURRENT_TIMESTAMP::TDateTime))
                       
   INSERT INTO _Result(RowData)
   SELECT
        '<Offer Code="'||CAST(Object_User.ObjectCode AS TVarChar)||'" Name="'||replace(replace(replace(Object_User.ValueData, '"', ''),'&','&amp;'),'''','')||'" Password="'||digest(ObjectString_User_.ValueData::Text, 'md5')||'" Result="'||CASE WHEN tmpResult.Result IS NULL THEN 'Null' ELSE tmpResult.Result::Text END||'" DateTimeTest="'||CASE WHEN tmpResult.DateTimeTest IS NULL THEN 'Null' ELSE to_char(tmpResult.DateTimeTest, 'DD.MM.YYYY HH:MI:SS') END||'" />'
   
   FROM Object AS Object_User

        LEFT JOIN ObjectString AS ObjectString_User_
                               ON ObjectString_User_.ObjectId = Object_User.Id
                              AND ObjectString_User_.DescId = zc_ObjectString_User_Password()

        INNER JOIN ObjectLink AS ObjectLink_User_Member
                             ON ObjectLink_User_Member.ObjectId = Object_User.Id
                            AND ObjectLink_User_Member.DescId = zc_ObjectLink_User_Member()
        INNER JOIN Object AS Object_Member ON Object_Member.Id = ObjectLink_User_Member.ChildObjectId

        LEFT JOIN tmpPersonal ON tmpPersonal.MemberId = ObjectLink_User_Member.ChildObjectId
                             AND tmpPersonal.PositionId = 1672498
        
        LEFT JOIN tmpResult ON tmpResult.UserID = Object_User.Id
   WHERE Object_User.DescId = zc_Object_User()
     AND (tmpPersonal.MemberId IS NOT NULL OR tmpResult.UserID IS NOT NULL)
   ORDER BY Object_User.ObjectCode;

   --подвал
   INSERT INTO _Result(RowData) Values ('</Offers>');
        

   -- Результат
   RETURN QUERY
       SELECT _Result.RowData FROM _Result;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Object_ExportPharmacists (TVarChar) OWNER TO postgres;

-------------------------------------------------------------------------------
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Шаблий О.В.
 07.09.18         *
*/

-- тест
-- SELECT * FROM gpSelect_Object_ExportPharmacists ('3')