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
BEGIN

   CREATE EXTENSION IF NOT EXISTS pgcrypto;
   CREATE TEMP TABLE _Result(RowData TBlob) ON COMMIT DROP;
   
   SELECT Movement.Id
   INTO vbMovementId
   FROM Movement 
   WHERE Movement.DescId = zc_Movement_TestingUser()
   ORDER BY Movement.OperDate DESC
   LIMIT 1;
    
    --Шапка
   INSERT INTO _Result(RowData) Values ('<?xml version="1.0" encoding="utf-8"?>');

    -- Содержимое
   INSERT INTO _Result(RowData) Values ('<Offers>');
    --Тело

   INSERT INTO _Result(RowData)
   SELECT
        '<Offer Code="'||CAST(Object_User.ObjectCode AS TVarChar)||
             '" Name="'||replace(replace(replace(Object_User.ValueData, '"', ''),'&','&amp;'),'''','')||
             '" Password="'||digest(ObjectString_User_.ValueData::Text, 'md5')||'" />'

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
                                                         
   WHERE Object_User.DescId = zc_Object_User()
     AND ObjectLink_Member_Position.ChildObjectId = 1672498
     AND ObjectString_User_.ValueData <> ''
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
 15.10.18         *
 07.09.18         *
*/

-- тест
-- SELECT * FROM gpSelect_Object_ExportPharmacists ('3')