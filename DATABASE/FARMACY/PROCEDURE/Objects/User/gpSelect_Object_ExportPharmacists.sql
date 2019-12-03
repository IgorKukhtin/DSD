-- Function: gpSelect_Object_ExportPharmacists (TVarChar)

DROP FUNCTION IF EXISTS gpSelect_Object_ExportPharmacists (TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_ExportPharmacists(
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (RowData TBlob)
AS
$BODY$
  DECLARE vbUserId Integer;
  DECLARE vbMovementId Integer;
  DECLARE vbMovementESID  Integer;
BEGIN

   CREATE EXTENSION IF NOT EXISTS pgcrypto;
   CREATE TEMP TABLE _Result(RowData TBlob) ON COMMIT DROP;
   
   SELECT Movement.Id
   INTO vbMovementId
   FROM Movement 
   WHERE Movement.DescId = zc_Movement_TestingUser()
   ORDER BY Movement.OperDate DESC
   LIMIT 1;
   
   IF EXISTS(SELECT 1 FROM Movement
             WHERE Movement.OperDate = date_trunc('month', CURRENT_DATE)
             AND Movement.DescId = zc_Movement_EmployeeSchedule())
   THEN
      SELECT Movement.ID
      INTO vbMovementESID
      FROM Movement
      WHERE Movement.OperDate = date_trunc('month', CURRENT_DATE)
        AND Movement.DescId = zc_Movement_EmployeeSchedule();
   ELSE
      vbMovementESID := 0;
   END IF;
       
    --Шапка
   INSERT INTO _Result(RowData) Values ('<?xml version="1.0" encoding="utf-8"?>');

    -- Содержимое
   INSERT INTO _Result(RowData) Values ('<Offers>');
    --Тело

   INSERT INTO _Result(RowData)
   (WITH
     tmpEmployeeSchedule AS (SELECT MIMaster.ObjectId  AS UserID 
                             FROM MovementItem AS MIMaster

                                 INNER JOIN MovementItem AS MIChild
                                                         ON MIChild.MovementId = vbMovementESID
                                                        AND MIChild.DescId = zc_MI_Child()
                                                        AND MIChild.ParentId = MIMaster.ID
                                                        AND MIChild.Amount = date_part('DAY',  CURRENT_DATE)::Integer

                                 LEFT JOIN MovementItemDate AS MIDate_Start
                                                             ON MIDate_Start.MovementItemId = MIChild.Id
                                                            AND MIDate_Start.DescId = zc_MIDate_Start()

                                 LEFT JOIN MovementItemDate AS MIDate_End
                                                            ON MIDate_End.MovementItemId = MIChild.Id
                                                           AND MIDate_End.DescId = zc_MIDate_End()

                                 LEFT JOIN MovementItemBoolean AS MIBoolean_ServiceExit
                                                               ON MIBoolean_ServiceExit.MovementItemId = MIChild.Id
                                                              AND MIBoolean_ServiceExit.DescId = zc_MIBoolean_ServiceExit()

                             WHERE MIMaster.MovementId = vbMovementESID
                               AND MIMaster.DescId = zc_MI_Master()
                               AND (COALESCE(MIBoolean_ServiceExit.ValueData, FALSE) = TRUE
                                OR MIBoolean_ServiceExit.ValueData IS NOT NULL AND MIDate_End.ValueData IS NOT NULL))
                   
   SELECT
        '<Offer Code="'||CAST(Object_User.ObjectCode AS TVarChar)||
             '" Name="'||replace(replace(replace(Object_User.ValueData, '"', ''),'&','&amp;'),'''','')||
             '" Password="'||digest(ObjectString_User_.ValueData::Text, 'md5')||
             '" AtWork="'||CASE WHEN COALESCE(tmpEmployeeSchedule.UserID, 0) = Object_User.ID THEN 'True' ELSE 'False' END||'" />'

   FROM Object AS Object_User

        INNER JOIN ObjectString AS ObjectString_User_
                                ON ObjectString_User_.ObjectId = Object_User.Id
                               AND ObjectString_User_.DescId = zc_ObjectString_User_Password()

        INNER JOIN ObjectLink AS ObjectLink_User_Member
                              ON ObjectLink_User_Member.ObjectId = Object_User.Id
                             AND ObjectLink_User_Member.DescId = zc_ObjectLink_User_Member()

        INNER JOIN ObjectLink AS ObjectLink_Member_Position
                              ON ObjectLink_Member_Position.ObjectId = ObjectLink_User_Member.ChildObjectId
                             AND ObjectLink_Member_Position.DescId = zc_ObjectLink_Member_Position()
                             
        LEFT JOIN tmpEmployeeSchedule ON tmpEmployeeSchedule.UserID = Object_User.ID
                                                         
   WHERE Object_User.DescId = zc_Object_User()
     AND ObjectLink_Member_Position.ChildObjectId = 1672498
     AND ObjectString_User_.ValueData <> ''
   ORDER BY Object_User.ObjectCode);

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
 03.12.19         *
 15.10.18         *
 07.09.18         *
*/

-- тест select * from gpSelect_Object_ExportPharmacists('3')-- SELECT * FROM gpSelect_Object_ExportPharmacists ('3')