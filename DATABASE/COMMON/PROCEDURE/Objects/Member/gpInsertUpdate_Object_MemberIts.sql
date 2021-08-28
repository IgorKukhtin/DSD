-- Function: gpInsertUpdate_Object_MemberIts(Integer, Integer, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar)

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_MemberIts (Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, 
                                                         TDateTime, TDateTime, TDateTime, TDateTime, TDateTime, TDateTime, TDateTime, TDateTime, TDateTime, TDateTime, 
                                                         TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar);


CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_MemberIts(
    IN inId	             Integer   ,    -- ключ объекта <Физические лица> 
    IN inGenderId            Integer   ,    --
    IN inMemberSkillId       Integer   ,    --
    IN inJobSourceId         Integer   ,    --
    IN inRegionId            Integer   ,    --
    IN inRegionId_Real       Integer   ,    --
    IN inCityId              Integer   ,    --
    IN inCityId_Real         Integer   ,    --

    IN inBirthday_date       TDateTime ,
    IN inChildren1_date      TDateTime ,
    IN inChildren2_date      TDateTime ,
    IN inChildren3_date      TDateTime ,
    IN inChildren4_date      TDateTime ,
    IN inChildren5_date      TDateTime ,
    IN inPSP_Startdate       TDateTime ,
    IN inPSP_Enddate         TDateTime ,
    IN inDekret_StartDate    TDateTime ,
    IN inDekret_EndDate      TDateTime ,
    
    IN inStreet              TVarChar ,
    IN inStreet_Real         TVarChar ,
    IN inChildren1           TVarChar ,
    IN inChildren2           TVarChar ,
    IN inChildren3           TVarChar ,
    IN inChildren4           TVarChar ,
    IN inChildren5           TVarChar ,
    IN inLaw                 TVarChar ,
    IN inDriverCertificateAdd  TVarChar ,
    IN inPSP_S               TVarChar ,
    IN inPSP_N               TVarChar ,
    IN inPSP_W               TVarChar ,
    IN inPSP_D               TVarChar ,

    IN inSession             TVarChar       -- сессия пользователя
)
  RETURNS VOID AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN

   -- проверка прав пользователя на вызов процедуры
   vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_Member());
   
   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectString( zc_ObjectString_Member_Street(), inId, inStreet);
   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectString( zc_ObjectString_Member_Street_Real(), inId, inStreet_Real);
   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectString( zc_ObjectString_Member_Children1(), inId, inChildren1);
   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectString( zc_ObjectString_Member_Children2(), inId, inChildren2);
   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectString( zc_ObjectString_Member_Children3(), inId, inChildren3);
   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectString( zc_ObjectString_Member_Children4(), inId, inChildren4);
   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectString( zc_ObjectString_Member_Children5(), inId, inChildren5);
   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectString( zc_ObjectString_Member_Law(), inId, inLaw);
   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectString( zc_ObjectString_Member_DriverCertificateAdd(), inId, inDriverCertificateAdd);
   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectString( zc_ObjectString_Member_PSP_S(), inId, inPSP_S);
   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectString( zc_ObjectString_Member_PSP_N(), inId, inPSP_N);
   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectString( zc_ObjectString_Member_PSP_W(), inId, inPSP_W);
   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectString( zc_ObjectString_Member_PSP_D(), inId, inPSP_D);
      
   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectDate( zc_ObjectDate_Member_Birthday(), inId, CASE WHEN inBirthday_date = CURRENT_DATE THEN NULL ELSE inBirthday_date END);
   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectDate( zc_ObjectDate_Member_Children1(), inId, CASE WHEN TRIM (inChildren1) <> '' THEN inChildren1_date ELSE NULL END);
   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectDate( zc_ObjectDate_Member_Children2(), inId, CASE WHEN TRIM (inChildren2) <> '' THEN inChildren2_date ELSE NULL END);
   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectDate( zc_ObjectDate_Member_Children3(), inId, CASE WHEN TRIM (inChildren3) <> '' THEN inChildren3_date ELSE NULL END);
   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectDate( zc_ObjectDate_Member_Children4(), inId, CASE WHEN TRIM (inChildren4) <> '' THEN inChildren4_date ELSE NULL END);
   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectDate( zc_ObjectDate_Member_Children5(), inId, CASE WHEN TRIM (inChildren5) <> '' THEN inChildren5_date ELSE NULL END);
   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectDate( zc_ObjectDate_Member_PSP_Start(), inId, CASE WHEN inPSP_StartDate = CURRENT_DATE THEN NULL ELSE inPSP_StartDate END);
   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectDate( zc_ObjectDate_Member_PSP_End(), inId, CASE WHEN inPSP_EndDate = CURRENT_DATE THEN NULL ELSE inPSP_EndDate END);
   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectDate( zc_ObjectDate_Member_Dekret_Start(), inId, CASE WHEN inDekret_StartDate = CURRENT_DATE THEN NULL ELSE inDekret_StartDate END);
   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectDate( zc_ObjectDate_Member_Dekret_End(), inId, CASE WHEN inDekret_EndDate = CURRENT_DATE THEN NULL ELSE inDekret_EndDate END);

   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectLink( zc_ObjectLink_Member_Gender(), inId, inGenderId);
   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectLink( zc_ObjectLink_Member_MemberSkill(), inId, inMemberSkillId);
   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectLink( zc_ObjectLink_Member_JobSource(), inId, inJobSourceId);
   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectLink( zc_ObjectLink_Member_Region(), inId, inRegionId);
   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectLink( zc_ObjectLink_Member_City(), inId, inCityId);
   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectLink( zc_ObjectLink_Member_Region_Real(), inId, inRegionId_Real);
   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectLink( zc_ObjectLink_Member_City_Real(), inId, inCityId_Real);
   
END;$BODY$
  LANGUAGE plpgsql VOLATILE;


/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 05.08.21         * 
*/

--