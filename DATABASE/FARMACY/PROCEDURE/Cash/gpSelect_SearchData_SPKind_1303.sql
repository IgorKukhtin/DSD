-- Function: gpSelect_SearchData_SPKind_1303()

DROP FUNCTION IF EXISTS gpSelect_SearchData_SPKind_1303 (Integer, Integer, Integer, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_SearchData_SPKind_1303(
    IN inInstitution_Id      Integer   , -- Id мед. учереждения
    IN inDoctor_Id           Integer   , -- Id врача
    IN inPatient_Id          Integer   , -- Id пациента
    IN inInstitution_Edrpou  TVarChar  , -- Окпо мед учереждения
   OUT outPartnerMedicalId   Integer   , -- Медицинское учреждение
   OUT outPartnerMedicalName TVarChar  , -- Медицинское учреждение
   OUT outMedicSPId          Integer   , -- ФИО врача (Соц. проект)
   OUT outMedicSPName        TVarChar  , -- ФИО врача (Соц. проект)
   OUT outMemberSPId         Integer   , -- ФИО пациента (Соц. проект)
   OUT outMemberSPName       TVarChar  , -- ФИО пациента (Соц. проект)
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
    outMedicSPId := 0;
    outMedicSPName := '';
    outMemberSPId := 0;
    outMemberSPName := '';

    IF EXISTS(SELECT ObjectFloat.ObjectId FROM ObjectFloat
                    INNER JOIN Object ON Object.ID = ObjectFloat.ObjectId
                                     AND Object.DescId = zc_Object_PartnerMedical()
              WHERE ObjectFloat.DescId = zc_ObjectFloat_PartnerMedical_LikiDniproId()
                AND ObjectFloat.ValueData = outMedicSPId)
    THEN

      SELECT Object.ID, Object.ValueData
      INTO outPartnerMedicalId, outPartnerMedicalName
      FROM ObjectFloat
           INNER JOIN Object ON Object.ID = ObjectFloat.ObjectId
                            AND Object.DescId = zc_Object_PartnerMedical()
      WHERE ObjectFloat.DescId = zc_ObjectFloat_PartnerMedical_LikiDniproId()
        AND ObjectFloat.ValueData = outMedicSPId;

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

    IF EXISTS(SELECT ObjectFloat.ObjectId FROM ObjectFloat
                    INNER JOIN Object ON Object.ID = ObjectFloat.ObjectId
                                     AND Object.DescId = zc_Object_MedicSP()
              WHERE ObjectFloat.DescId = zc_ObjectFloat_MedicSP_LikiDniproId()
                AND ObjectFloat.ValueData = outMedicSPId)
    THEN

      SELECT Object.ID, Object.ValueData
      INTO outMedicSPId, outMedicSPName
      FROM ObjectFloat
           INNER JOIN Object ON Object.ID = ObjectFloat.ObjectId
                            AND Object.DescId = zc_Object_MedicSP()
      WHERE ObjectFloat.DescId = zc_ObjectFloat_MedicSP_LikiDniproId()
        AND ObjectFloat.ValueData = outMedicSPId;

    END IF;

    IF EXISTS(SELECT ObjectFloat.ObjectId FROM ObjectFloat
                    INNER JOIN Object ON Object.ID = ObjectFloat.ObjectId
                                     AND Object.DescId = zc_Object_MemberSP()
              WHERE ObjectFloat.DescId = zc_ObjectFloat_MemberSP_LikiDniproId()
                AND ObjectFloat.ValueData = inPatient_Id)
    THEN

      SELECT Object.ID, Object.ValueData
      INTO outMemberSPId, outMemberSPName
      FROM ObjectFloat
           INNER JOIN Object ON Object.ID = ObjectFloat.ObjectId
                            AND Object.DescId = zc_Object_MemberSP()
      WHERE ObjectFloat.DescId = zc_ObjectFloat_MemberSP_LikiDniproId()
        AND ObjectFloat.ValueData = inPatient_Id;

    END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 01.03.21                                                       *
*/

--
SELECT * FROM gpSelect_SearchData_SPKind_1303(inInstitution_Id :=  0,inDoctor_Id :=  0, inPatient_Id :=  0, inInstitution_Edrpou :=  '', inSession := '3');