 -- Function: gpGet_GoodsSearchRemains_1303()

DROP FUNCTION IF EXISTS gpGet_GoodsSearchRemains_1303 (TVarChar);

CREATE OR REPLACE FUNCTION gpGet_GoodsSearchRemains_1303(
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (GuidesPartnerMedicalId Integer, GuidesPartnerMedicalName TVarChar, isDisableGuides Boolean
             )
AS
$BODY$
    DECLARE vbUserId Integer;
    DECLARE vbUnitId Integer;
    DECLARE vbUnitKey TVarChar;
    DECLARE vbGuidesPartnerMedicalId Integer; 
    DECLARE vbGuidesPartnerMedicalName TVarChar;
    DECLARE vbisDisableGuides Boolean;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_MovementItem_GoodsSPSearch_1303());
    vbUserId:= lpGetUserBySession (inSession);
    vbUnitKey := COALESCE(lpGet_DefaultValue('zc_Object_Unit', vbUserId), '');
    IF vbUnitKey = '' THEN
       vbUnitKey := '0';
    END IF;
    vbUnitId := vbUnitKey::Integer;
    
    SELECT Object_PartnerMedical.Id                     AS PartnerMedicalId
         , Object_PartnerMedical.ValueData              AS PartnerMedicalName
    INTO vbGuidesPartnerMedicalId, vbGuidesPartnerMedicalName
    FROM ObjectLink AS ObjectLink_Unit_PartnerMedical
                                                 
         LEFT JOIN Object AS Object_PartnerMedical ON Object_PartnerMedical.Id = ObjectLink_Unit_PartnerMedical.ChildObjectId
         
    WHERE ObjectLink_Unit_PartnerMedical.ObjectId = vbUnitId
      AND ObjectLink_Unit_PartnerMedical.DescId = zc_ObjectLink_Unit_PartnerMedical();
      
    vbisDisableGuides := EXISTS (SELECT 1 FROM ObjectLink_UserRole_View  WHERE UserId = vbUserId AND RoleId = zc_Enum_Role_CashierPharmacy());
    
    IF vbisDisableGuides AND COALESCE (vbGuidesPartnerMedicalId, 0) = 0
    THEN
      RAISE EXCEPTION 'Ошибка. Для подразделения не установлен "Мед. учреждение для пкму 1303".';    
    END IF;
    
    RETURN QUERY
    SELECT vbGuidesPartnerMedicalId, vbGuidesPartnerMedicalName, vbisDisableGuides;
    
END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 12.07.22                                                       *
*/

--ТЕСТ
-- 
SELECT * FROM gpGet_GoodsSearchRemains_1303 (inSession:= '3')