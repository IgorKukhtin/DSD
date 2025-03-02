-- Function: zfGet_Branch_AccessKey

DROP FUNCTION IF EXISTS zfGet_Branch_AccessKey (Integer);

CREATE OR REPLACE FUNCTION zfGet_Branch_AccessKey (inAccessKeyId Integer)
RETURNS Integer
AS
$BODY$
 DECLARE vbBranchId Integer;
BEGIN
     vbBranchId:= CASE -- просто - ХЛЕБ
                       WHEN inAccessKeyId = zc_Enum_Process_AccessKey_DocumentBread()

                            THEN (SELECT Id FROM Object WHERE DescId = zc_Object_Branch() AND AccessKeyId = zc_Enum_Process_AccessKey_TrasportDnepr())
                            
                       -- филиал - "ГЛАВНЫЙ"
                       WHEN inAccessKeyId IN (zc_Enum_Process_AccessKey_DocumentDnepr()
                                            , zc_Enum_Process_AccessKey_CashDnepr()
                                            , zc_Enum_Process_AccessKey_CashOfficialDnepr()
                                            , zc_Enum_Process_AccessKey_ServiceDnepr()
                                            , zc_Enum_Process_AccessKey_ServicePav()
                                            , zc_Enum_Process_AccessKey_TrasportDnepr()
                                            --, zc_Enum_Process_AccessKey_PersonalService...()
                                            , zc_Enum_Process_AccessKey_PersonalServiceProduction()
                                            , zc_Enum_Process_AccessKey_PersonalServiceAdmin()
                                            , zc_Enum_Process_AccessKey_PersonalServiceSbit()
                                            , zc_Enum_Process_AccessKey_PersonalServiceMarketing()
                                            , zc_Enum_Process_AccessKey_PersonalServiceSB()
                                            , zc_Enum_Process_AccessKey_PersonalServiceFirstForm()
                                            , zc_Enum_Process_AccessKey_PersonalServiceSbitM()
                                            , zc_Enum_Process_AccessKey_PersonalServicePav()
                                            , zc_Enum_Process_AccessKey_PersonalServiceOther()
                                             )
                            THEN (SELECT Id FROM Object WHERE DescId = zc_Object_Branch() AND AccessKeyId = zc_Enum_Process_AccessKey_TrasportDnepr())
                       -- филиал - Kiev
                       WHEN inAccessKeyId IN (zc_Enum_Process_AccessKey_DocumentKiev()
                                            , zc_Enum_Process_AccessKey_CashKiev()
                                            , zc_Enum_Process_AccessKey_PersonalServiceKiev()
                                            , zc_Enum_Process_AccessKey_ServiceKiev()
                                            , zc_Enum_Process_AccessKey_TrasportKiev()
                                             )
                            THEN (SELECT Id FROM Object WHERE DescId = zc_Object_Branch() AND AccessKeyId = zc_Enum_Process_AccessKey_TrasportKiev())

                       -- филиал - Lviv
                       WHEN inAccessKeyId IN (zc_Enum_Process_AccessKey_DocumentLviv()
                                            , zc_Enum_Process_AccessKey_CashLviv()
                                            , zc_Enum_Process_AccessKey_PersonalServiceLviv()
                                            , zc_Enum_Process_AccessKey_ServiceLviv()
                                            , zc_Enum_Process_AccessKey_TrasportLviv()
                                             )
                            THEN (SELECT Id FROM Object WHERE DescId = zc_Object_Branch() AND AccessKeyId = zc_Enum_Process_AccessKey_TrasportLviv())

                       -- филиал - Vinnica
                       WHEN inAccessKeyId IN (zc_Enum_Process_AccessKey_DocumentVinnica()
                                            , zc_Enum_Process_AccessKey_CashVinnica()
                                            , zc_Enum_Process_AccessKey_PersonalServiceVinnica()
                                            , zc_Enum_Process_AccessKey_ServiceVinnica()
                                            , zc_Enum_Process_AccessKey_TrasportVinnica()
                                             )
                            THEN (SELECT Id FROM Object WHERE DescId = zc_Object_Branch() AND AccessKeyId = zc_Enum_Process_AccessKey_TrasportVinnica())

                       -- филиал - Ирна
                       WHEN inAccessKeyId IN (zc_Enum_Process_AccessKey_DocumentIrna()
                                            , zc_Enum_Process_AccessKey_CashIrna()
                                            , zc_Enum_Process_AccessKey_PersonalServiceIrna()
                                            , zc_Enum_Process_AccessKey_ServiceIrna()
                                            , zc_Enum_Process_AccessKey_TrasportIrna()
                                             )
                            THEN (SELECT Id FROM Object WHERE DescId = zc_Object_Branch() AND AccessKeyId = zc_Enum_Process_AccessKey_TrasportIrna())

                       -- филиал - Odessa
                       WHEN inAccessKeyId IN (zc_Enum_Process_AccessKey_DocumentOdessa()
                                            , zc_Enum_Process_AccessKey_CashOdessa()
                                            , zc_Enum_Process_AccessKey_PersonalServiceOdessa()
                                            , zc_Enum_Process_AccessKey_ServiceOdessa()
                                            , zc_Enum_Process_AccessKey_TrasportOdessa()
                                             )
                            THEN (SELECT Id FROM Object WHERE DescId = zc_Object_Branch() AND AccessKeyId = zc_Enum_Process_AccessKey_TrasportOdessa())

                       -- филиал - Zaporozhye
                       WHEN inAccessKeyId IN (zc_Enum_Process_AccessKey_DocumentZaporozhye()
                                            , zc_Enum_Process_AccessKey_CashZaporozhye()
                                            , zc_Enum_Process_AccessKey_PersonalServiceZaporozhye()
                                            , zc_Enum_Process_AccessKey_ServiceZaporozhye()
                                            , zc_Enum_Process_AccessKey_TrasportZaporozhye()
                                             )
                            THEN (SELECT Id FROM Object WHERE DescId = zc_Object_Branch() AND AccessKeyId = zc_Enum_Process_AccessKey_TrasportZaporozhye())

                       -- филиал - KrRog
                       WHEN inAccessKeyId IN (zc_Enum_Process_AccessKey_DocumentKrRog()
                                            , zc_Enum_Process_AccessKey_CashKrRog()
                                            , zc_Enum_Process_AccessKey_PersonalServiceKrRog()
                                            , zc_Enum_Process_AccessKey_ServiceKrRog()
                                            , zc_Enum_Process_AccessKey_TrasportKrRog()
                                             )
                            THEN (SELECT Id FROM Object WHERE DescId = zc_Object_Branch() AND AccessKeyId = zc_Enum_Process_AccessKey_TrasportKrRog())

                       -- филиал - Nikolaev
                       WHEN inAccessKeyId IN (zc_Enum_Process_AccessKey_DocumentNikolaev()
                                            , zc_Enum_Process_AccessKey_CashNikolaev()
                                            , zc_Enum_Process_AccessKey_PersonalServiceNikolaev()
                                            , zc_Enum_Process_AccessKey_ServiceNikolaev()
                                            , zc_Enum_Process_AccessKey_TrasportNikolaev()
                                             )
                            THEN (SELECT Id FROM Object WHERE DescId = zc_Object_Branch() AND AccessKeyId = zc_Enum_Process_AccessKey_TrasportNikolaev())

                       -- филиал - Kharkov
                       WHEN inAccessKeyId IN (zc_Enum_Process_AccessKey_DocumentKharkov()
                                            , zc_Enum_Process_AccessKey_CashKharkov()
                                            , zc_Enum_Process_AccessKey_PersonalServiceKharkov()
                                            , zc_Enum_Process_AccessKey_ServiceKharkov()
                                            , zc_Enum_Process_AccessKey_TrasportKharkov()
                                             )
                            THEN (SELECT Id FROM Object WHERE DescId = zc_Object_Branch() AND AccessKeyId = zc_Enum_Process_AccessKey_TrasportKharkov())

                       -- филиал - Cherkassi
                       WHEN inAccessKeyId IN (zc_Enum_Process_AccessKey_DocumentCherkassi()
                                            , zc_Enum_Process_AccessKey_CashCherkassi()
                                            , zc_Enum_Process_AccessKey_PersonalServiceCherkassi()
                                            , zc_Enum_Process_AccessKey_ServiceCherkassi()
                                            , zc_Enum_Process_AccessKey_TrasportCherkassi()
                                             )
                            THEN (SELECT Id FROM Object WHERE DescId = zc_Object_Branch() AND AccessKeyId = zc_Enum_Process_AccessKey_TrasportCherkassi())

                       -- филиал - Doneck
                       /*WHEN inAccessKeyId IN (zc_Enum_Process_AccessKey_DocumentDoneck()
                                            , zc_Enum_Process_AccessKey_CashDoneck()
                                            , zc_Enum_Process_AccessKey_PersonalServiceDoneck()
                                            , zc_Enum_Process_AccessKey_TrasportDoneck()
                                             )
                            THEN (SELECT Id FROM Object WHERE DescId = zc_Object_Branch() AND AccessKeyId = zc_Enum_Process_AccessKey_TrasportDoneck())
                       */
                  END;
     -- проверка
     IF COALESCE (vbBranchId, 0) = 0
     THEN
         RAISE EXCEPTION 'Ошибка.Не возможно определить <Филиал>.<%>', inAccessKeyId;
     END IF;
     --
     RETURN (vbBranchId);
END;
$BODY$
  LANGUAGE PLPGSQL IMMUTABLE;
ALTER FUNCTION zfGet_Branch_AccessKey (Integer) OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 03.02.16                                        *
*/

-- тест
-- SELECT zfGet_Branch_AccessKey (zc_Enum_Process_AccessKey_DocumentDnepr())
