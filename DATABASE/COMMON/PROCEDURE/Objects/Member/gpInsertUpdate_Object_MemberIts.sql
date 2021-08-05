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
   PERFORM lpInsertUpdate_ObjectDate( zc_ObjectDate_Member_Birthday(), inId, inEMailSign);
   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectDate( zc_ObjectDate_Member_Children1(), inId, inChildren1_date);
   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectDate( zc_ObjectDate_Member_Children2(), inId, inChildren2_date);
   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectDate( zc_ObjectDate_Member_Children3(), inId, inChildren3_date);
   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectDate( zc_ObjectDate_Member_Children4(), inId, inChildren4_date);
   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectDate( zc_ObjectDate_Member_Children5(), inId, inChildren5_date);
   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectDate( zc_ObjectDate_Member_PSP_Start(), inId, inPSP_StartDate);
   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectDate( zc_ObjectDate_Member_PSP_End(), inId, inPSP_EndDate);
   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectDate( zc_ObjectDate_Member_Dekret_Start(), inId, inDekret_StartDate);
   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectDate( zc_ObjectDate_Member_Dekret_End(), inId, inDekret_EndDate);

   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectLink( zc_ObjectLink_Member_Gender(), ioId, inGenderId);
   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectLink( zc_ObjectLink_Member_MemberSkill(), ioId, inMemberSkillId);
   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectLink( zc_ObjectLink_Member_JobSource(), ioId, inJobSourceId);
   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectLink( zc_ObjectLink_Member_Region(), ioId, inRegionId);
   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectLink( zc_ObjectLink_Member_City(), ioId, inCityId);
   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectLink( zc_ObjectLink_Member_Region_Real(), ioId, inRegionId_Real);
   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectLink( zc_ObjectLink_Member_City_Real(), ioId, inCityId_Real);
   
END;$BODY$
  LANGUAGE plpgsql VOLATILE;


/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 05.08.21         * 
*/

--