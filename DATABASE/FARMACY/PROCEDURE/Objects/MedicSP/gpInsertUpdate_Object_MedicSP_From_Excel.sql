-- Function: gpInsertUpdate_Object_MedicSP_From_Excel()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_MedicSP_From_Excel (TVarChar, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_MedicSP_From_Excel(
    IN inMedicSPName         TVarChar  ,    -- ФИО врача
    IN inPartnerMedicalName  TVarChar  ,    -- Мед.учреждение
    IN inSession             TVarChar       -- текущий пользователь
)
RETURNS Void
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbMedicSPId Integer;
   DECLARE vbPartnerMedicalId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpCheckRight(inSession, zc_Enum_Process_...());
     vbUserId:= lpGetUserBySession (inSession);

     -- проверка 
     IF COALESCE (inMedicSPName, '') = '' THEN
        RETURN;                                 --RAISE EXCEPTION 'Ошибка.Значение <inMedicSPName> должно быть установлено.';
     END IF; 

     -- проверка 
     IF COALESCE (inPartnerMedicalName, '') = '' THEN
        RAISE EXCEPTION 'Ошибка.Значение <Мед.учреждение> должно быть установлено.';
     END IF; 

     -- !!!поиск мед.учрежд!!!
     vbPartnerMedicalId:= (SELECT Object.Id
                           FROM Object
                           WHERE Object.DescId = zc_Object_PartnerMedical()
                             AND UPPER (Object.ValueData) LIKE UPPER (inPartnerMedicalName)
                           );
   
     IF COALESCE (vbPartnerMedicalId, 0) = 0 THEN
        RAISE EXCEPTION 'Ошибка.Мед.учреждение % не найдено в справочнике.', inPartnerMedicalName;
     END IF;  
   
     -- Ищем Врача найденного учреждения
     vbMedicSPId:= (SELECT Object_MedicSP.Id
                    FROM Object AS Object_MedicSP
                         INNER JOIN ObjectLink AS ObjectLink_MedicSP_PartnerMedical
                                 ON ObjectLink_MedicSP_PartnerMedical.ObjectId = Object_MedicSP.Id
                                AND ObjectLink_MedicSP_PartnerMedical.DescId = zc_ObjectLink_MedicSP_PartnerMedical()
                                AND ObjectLink_MedicSP_PartnerMedical.ChildObjectId = vbPartnerMedicalId
                    WHERE Object_MedicSP.DescId = zc_Object_MedicSP()
                      AND UPPER (Object_MedicSP.ValueData) LIKE UPPER (inMedicSPName)
                    );

     -- записываем новый эл. ФИО врача
     IF COALESCE (vbMedicSPId, 0) = 0 THEN
        PERFORM gpInsertUpdate_Object_MedicSP
                                           (ioId               := 0
                                          , inCode             := lfGet_ObjectCode(0, zc_Object_MedicSP())
                                          , inName             := TRIM(inMedicSPName)  ::TVarChar
                                          , inPartnerMedicalId := vbPartnerMedicalId
                                          , inAmbulantClinicSP := 0
                                          , inSession          := inSession
                                          );
     END IF;  
     


   
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 20.11.20                                                       *
 06.05.17         *
*/

-- тест
-- SELECT * FROM gpInsertUpdate_Object_MedicSP_From_Excel (324, '17', True, 4::TFloat, 5::TFloat, 0, 0, 0, '3');