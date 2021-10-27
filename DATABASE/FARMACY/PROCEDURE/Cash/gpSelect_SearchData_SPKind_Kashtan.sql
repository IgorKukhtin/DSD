-- Function: gpSelect_SearchData_SPKind_Kashtan()

--DROP FUNCTION IF EXISTS gpSelect_SearchData_SPKind_Kashtan (Integer, TVarChar, Integer, TVarChar, Integer, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpSelect_SearchData_SPKind_Kashtan (Integer, TVarChar, Integer, TVarChar, Integer, TVarChar, Integer, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_SearchData_SPKind_Kashtan(
    IN inInstitution_Id      Integer   , -- Id мед. учереждения
    IN inInstitution_Edrpou  TVarChar  , -- Окпо мед учереждения
    IN inDoctor_Id           Integer   , -- Id врача
    IN inDoctor_Name         TVarChar  , -- Имя врача
    IN inPatient_Id          Integer   , -- Id пациента
    IN inPatient_Name        TVarChar  , -- Имя пациента
    IN inCategory1303_Id     Integer   , -- Id категории
    IN inCategory1303_Name   TVarChar  , -- Имя категории
   OUT outPartnerMedicalId   Integer   , -- Медицинское учреждение
   OUT outPartnerMedicalName TVarChar  , -- Медицинское учреждение
   OUT outMedicKashtanId     Integer   , -- Id врача (МИС «Каштан»)
   OUT outMedicKashtanName   TVarChar  , -- ФИО врача (МИС «Каштан»)
   OUT outMemberKashtanId    Integer   , -- Id пациента (МИС «Каштан»)
   OUT outMemberKashtanName  TVarChar  , -- ФИО пациента (МИС «Каштан»)
   OUT outCategory1303Id     Integer   , -- Id категории
   OUT outCategory1303Name   TVarChar  , -- Название категории
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS record
AS
$BODY$
   DECLARE vbUserId    Integer;
   DECLARE vbUnitId Integer;
   DECLARE vbUnitKey TVarChar;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    --vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_Sale());
    vbUserId:= lpGetUserBySession (inSession);
    vbUnitKey := COALESCE(lpGet_DefaultValue('zc_Object_Unit', vbUserId), '');
    IF vbUnitKey = '' THEN
       vbUnitKey := '0';
    END IF;
    vbUnitId := vbUnitKey::Integer;

    outPartnerMedicalId := 0;
    outPartnerMedicalName := '';
    outMedicKashtanId := 0;
    outMedicKashtanName := '';
    outMemberKashtanId := 0;
    outMemberKashtanName := '';
    outCategory1303Id := 0;
    outCategory1303Name := '';

    IF EXISTS(SELECT ObjectFloat.ObjectId FROM ObjectFloat
                    INNER JOIN Object ON Object.ID = ObjectFloat.ObjectId
                                     AND Object.DescId = zc_Object_PartnerMedical()
              WHERE ObjectFloat.DescId = zc_ObjectFloat_PartnerMedical_LikiDniproId()
                AND ObjectFloat.ValueData = inInstitution_Id)
    THEN

      SELECT Object.ID, Object.ValueData
      INTO outPartnerMedicalId, outPartnerMedicalName
      FROM ObjectFloat
           INNER JOIN Object ON Object.ID = ObjectFloat.ObjectId
                            AND Object.DescId = zc_Object_PartnerMedical()
      WHERE ObjectFloat.DescId = zc_ObjectFloat_PartnerMedical_LikiDniproId()
        AND ObjectFloat.ValueData = inInstitution_Id;

    ELSEIF COALESCE (inInstitution_Edrpou, '') <> ''
            AND EXISTS(WITH tmpObjectHistory AS (SELECT *
                                                 FROM ObjectHistory
                                                 WHERE ObjectHistory.DescId = zc_ObjectHistory_JuridicalDetails()
                                                   AND ObjectHistory.enddate::timestamp with time zone = zc_dateend()::timestamp with time zone
                                                 )
                          , tmpJuridicalDetails AS (SELECT ObjectHistory_JuridicalDetails.ObjectId                                     AS JuridicalId
                                                         , ObjectHistoryString_JuridicalDetails_OKPO.ValueData                            AS OKPO
                                                 FROM tmpObjectHistory AS ObjectHistory_JuridicalDetails
                                                      LEFT JOIN ObjectHistoryString AS ObjectHistoryString_JuridicalDetails_OKPO
                                                             ON ObjectHistoryString_JuridicalDetails_OKPO.ObjectHistoryId = ObjectHistory_JuridicalDetails.Id
                                                            AND ObjectHistoryString_JuridicalDetails_OKPO.DescId = zc_ObjectHistoryString_JuridicalDetails_OKPO()

                                                 )

                      SELECT Object_PartnerMedical.ID, Object_PartnerMedical.ValueData
                      FROM Object AS Object_PartnerMedical

                           INNER JOIN ObjectLink AS ObjectLink_PartnerMedical_Juridical
                                                 ON ObjectLink_PartnerMedical_Juridical.ObjectId = Object_PartnerMedical.Id
                                                AND ObjectLink_PartnerMedical_Juridical.DescId = zc_ObjectLink_PartnerMedical_Juridical()
                           INNER JOIN tmpJuridicalDetails ON tmpJuridicalDetails.JuridicalId = ObjectLink_PartnerMedical_Juridical.ChildObjectId
                                                         AND tmpJuridicalDetails.OKPO = inInstitution_Edrpou

                      WHERE Object_PartnerMedical.DescId = zc_Object_PartnerMedical())
    THEN

       WITH tmpObjectHistory AS (SELECT *
                                 FROM ObjectHistory
                                 WHERE ObjectHistory.DescId = zc_ObjectHistory_JuridicalDetails()
                                   AND ObjectHistory.enddate::timestamp with time zone = zc_dateend()::timestamp with time zone
                                 )
          , tmpJuridicalDetails AS (SELECT ObjectHistory_JuridicalDetails.ObjectId                                     AS JuridicalId
                                         , ObjectHistoryString_JuridicalDetails_OKPO.ValueData                            AS OKPO
                                 FROM tmpObjectHistory AS ObjectHistory_JuridicalDetails
                                      LEFT JOIN ObjectHistoryString AS ObjectHistoryString_JuridicalDetails_OKPO
                                             ON ObjectHistoryString_JuridicalDetails_OKPO.ObjectHistoryId = ObjectHistory_JuridicalDetails.Id
                                            AND ObjectHistoryString_JuridicalDetails_OKPO.DescId = zc_ObjectHistoryString_JuridicalDetails_OKPO()

                                 )

      SELECT Object_PartnerMedical.ID, Object_PartnerMedical.ValueData
      INTO outPartnerMedicalId, outPartnerMedicalName
      FROM Object AS Object_PartnerMedical

           INNER JOIN ObjectLink AS ObjectLink_PartnerMedical_Juridical
                                 ON ObjectLink_PartnerMedical_Juridical.ObjectId = Object_PartnerMedical.Id
                                AND ObjectLink_PartnerMedical_Juridical.DescId = zc_ObjectLink_PartnerMedical_Juridical()
           INNER JOIN tmpJuridicalDetails ON tmpJuridicalDetails.JuridicalId = ObjectLink_PartnerMedical_Juridical.ChildObjectId
                                         AND tmpJuridicalDetails.OKPO = inInstitution_Edrpou

      WHERE Object_PartnerMedical.DescId = zc_Object_PartnerMedical()
      LIMIT 1;

    END IF;

    IF EXISTS(SELECT Object.Id FROM Object 
              WHERE Object.ObjectCode = inDoctor_Id
                AND Object.DescId = zc_Object_MedicKashtan())
    THEN

      SELECT Object.ID, Object.ValueData
      INTO outMedicKashtanId, outMedicKashtanName
      FROM Object 
      WHERE Object.ObjectCode = inDoctor_Id
        AND Object.DescId = zc_Object_MedicKashtan();

    END IF;
    
    IF COALESCE (outMedicKashtanId, 0) = 0 OR COALESCE (outMedicKashtanName, '') <> inDoctor_Name
    THEN
      outMedicKashtanName := inDoctor_Name;
      outMedicKashtanId := gpInsertUpdate_Object_MedicKashtan (outMedicKashtanId, inDoctor_Id, inDoctor_Name, inSession); 
    END IF;

    IF EXISTS(SELECT Object.Id FROM Object 
              WHERE Object.ObjectCode = inPatient_Id
                AND Object.DescId = zc_Object_MemberKashtan())
    THEN

      SELECT Object.ID, Object.ValueData
      INTO outMemberKashtanId, outMemberKashtanName
      FROM Object 
      WHERE Object.ObjectCode = inPatient_Id
        AND Object.DescId = zc_Object_MemberKashtan();

    END IF;

    IF COALESCE (outMemberKashtanId, 0) = 0 OR COALESCE (outMemberKashtanName, '') <> inPatient_Name
    THEN
      outMemberKashtanName := inPatient_Name;
      outMemberKashtanId := gpInsertUpdate_Object_MemberKashtan (outMemberKashtanId, inPatient_Id, inPatient_Name, inSession); 
    END IF;
    
    IF COALESCE (inCategory1303_Id, 0) <> 0
    THEN
      IF EXISTS(SELECT Object.Id FROM Object 
                WHERE Object.ObjectCode = inCategory1303_Id
                  AND Object.DescId = zc_Object_Category1303())
      THEN

        SELECT Object.ID, Object.ValueData
        INTO outCategory1303Id, outCategory1303Name
        FROM Object 
        WHERE Object.ObjectCode = inCategory1303_Id
          AND Object.DescId = zc_Object_Category1303();

      END IF;
      
      IF COALESCE (outCategory1303Id, 0) = 0
      THEN
        outCategory1303Name := inCategory1303_Name;
        outCategory1303Id := gpInsertUpdate_Object_Category1303 (outCategory1303Id, inCategory1303_Id, inCategory1303_Name, inSession); 
      END IF;
    END IF;
    

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 01.03.21                                                       *
*/

-- select * from gpSelect_SearchData_SPKind_Kashtan(inInstitution_Id := 10 , inInstitution_Edrpou := '37899872' , inDoctor_Id := 1238 , inDoctor_Name := 'Давидова Наталія Петрівна' , inPatient_Id := 53426 , inPatient_Name := 'Аістова Анастасія Петрівна' ,  inSession := '3');