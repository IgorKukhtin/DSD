-- Function: gpGet_AvailabilityCheckMedicalProgram(TVarChar)

DROP FUNCTION IF EXISTS gpGet_AvailabilityCheckMedicalProgram(Integer, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_AvailabilityCheckMedicalProgram(
    IN inSPKindId             Integer   ,  -- ключ объекта <СП> 
    IN inProgramId            TVarChar  ,  -- ключ объекта <Программа> 
   OUT outMedicalProgramSPID  Integer   , 
    IN inSession              TVarChar     -- сессия пользователя
)
RETURNS Integer
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbUnitId Integer;
   DECLARE vbUnitKey TVarChar;
   DECLARE vbRetailId Integer;
   DECLARE vbMovementID Integer;
   DECLARE vbNotSchedule Boolean;
BEGIN

    -- проверка прав пользователя на вызов процедуры
    -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_SheetWorkTime());
    vbUserId:= lpGetUserBySession (inSession);
    vbUnitKey := COALESCE(lpGet_DefaultValue('zc_Object_Unit', vbUserId), '');
    IF vbUnitKey = '' THEN
       vbUnitKey := '0';
    END IF;
    vbUnitId := vbUnitKey::Integer;
    
    SELECT ObjectLink_MedicalProgramSP.ChildObjectId
    INTO outMedicalProgramSPID
    FROM Object AS Object_MedicalProgramSPLink
         INNER JOIN ObjectLink AS ObjectLink_MedicalProgramSP
                               ON ObjectLink_MedicalProgramSP.ObjectId = Object_MedicalProgramSPLink.Id
                              AND ObjectLink_MedicalProgramSP.DescId = zc_ObjectLink_MedicalProgramSPLink_MedicalProgramSP()
         INNER JOIN ObjectString AS ObjectString_ProgramId 	
                                 ON ObjectString_ProgramId.ObjectId = ObjectLink_MedicalProgramSP.ChildObjectId
                                AND ObjectString_ProgramId.DescId = zc_ObjectString_MedicalProgramSP_ProgramId()
                                AND ObjectString_ProgramId.ValueData = inProgramId
         INNER JOIN ObjectLink AS ObjectLink_Unit
                               ON ObjectLink_Unit.ObjectId = Object_MedicalProgramSPLink.Id
                              AND ObjectLink_Unit.DescId = zc_ObjectLink_MedicalProgramSPLink_Unit()
                              AND ObjectLink_Unit.ChildObjectId = vbUnitId
    WHERE Object_MedicalProgramSPLink.DescId = zc_Object_MedicalProgramSPLink()
      AND Object_MedicalProgramSPLink.isErased = False;
      
    IF COALESCE (outMedicalProgramSPID, 0) = 0 AND vbUserId = 3
    THEN
      SELECT Object_MedicalProgramSP.Id
      INTO outMedicalProgramSPID
      FROM Object AS Object_MedicalProgramSP
           INNER JOIN ObjectString AS ObjectString_ProgramId 	
                                   ON ObjectString_ProgramId.ObjectId = Object_MedicalProgramSP.Id
                                  AND ObjectString_ProgramId.DescId = zc_ObjectString_MedicalProgramSP_ProgramId()
                                  AND ObjectString_ProgramId.ValueData = inProgramId
      WHERE Object_MedicalProgramSP.DescId = zc_Object_MedicalProgramSP();
    END IF;

    IF COALESCE (outMedicalProgramSPID, 0) = 0
    THEN
      outMedicalProgramSPID := 0;
    END IF;    
    
END;
$BODY$

LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 04.10.21                                                       *
*/

-- тест select * from gpGet_AvailabilityCheckMedicalProgram(inSPKindId := 4823009 , inProgramId := '857588d8-9e12-4935-96c4-b08e95d19dce' ,  inSession := '3');
select * from gpGet_AvailabilityCheckMedicalProgram(inSPKindId := 4823009 , inProgramId := 'f217889f-736f-462c-8f8b-ed99edddb3be' ,  inSession := '3990942');