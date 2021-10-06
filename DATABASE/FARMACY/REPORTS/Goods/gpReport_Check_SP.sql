-- Function:  gpReport_Check_SP()

DROP FUNCTION IF EXISTS gpReport_Check_SP (TDateTime, TDateTime, TVarChar);
DROP FUNCTION IF EXISTS gpReport_Check_SP (TDateTime, TDateTime, Integer,Integer,Integer, TVarChar);
DROP FUNCTION IF EXISTS gpReport_Check_SP (TDateTime, TDateTime, Integer,Integer,Integer,Integer, TVarChar);
DROP FUNCTION IF EXISTS gpReport_Check_SP (TDateTime, TDateTime, Integer,Integer,Integer,Integer,Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_Check_SP(
    IN inStartDate           TDateTime,  -- Дата начала
    IN inEndDate             TDateTime,  -- Дата окончания
    IN inJuridicalId         Integer  ,  -- Юр.лицо
    IN inUnitId              Integer  ,  -- Аптека
    IN inHospitalId          Integer  ,  -- Больница
    IN inJuridicalMedicId    Integer  ,  -- Юр.лицо плательщик с 01,04,2019
    IN inMedicalProgramSPId  Integer  ,  -- Медицинская программа соц. проектов
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS TABLE (MovementId     Integer
             , InvNumber_Full TVarChar
             , UnitName       TVarChar
             , JuridicalId    Integer
             , JuridicalName  TVarChar
             , HospitalId     Integer
             , HospitalName   TVarChar
             , GoodsCode      Integer
             , GoodsName      TVarChar
             , IntenalSPName  TVarChar
             , BrandSPName    TVarChar
             , KindOutSPName  TVarChar
             , Pack           TVarChar
             , CountSP        TFloat
             , PriceSP        TFloat 
             , GroupSP        TFloat 
             , CodeATX        TVarChar
             , ReestrSP       TVarChar
             , MakerSP        TVarChar
             , DateReestrSP   TVarChar
             , PriceOptSP     TFloat
             , PriceRetSP     TFloat
             , DailyNormSP    TFloat
             , DailyCompensationSP  TFloat
             , PaymentSP      TFloat
             , ColSP          TFloat
             , InsertDateSP   TDateTime

             , Amount         TFloat
             , PriceSale      TFloat
             , PriceCheckSP   TFloat 
             , PriceWithVAT   TFloat 
             , SummaSP        TFloat
             , SummaSale      TFloat
             , SummaSP_pack   TFloat
             , NumLine        Integer
             , CountInvNumberSP  Integer

             , JuridicalFullName  TVarChar
             , JuridicalAddress   TVarChar
             , OKPO               TVarChar
             , MainName           TVarChar
             , MainName_Cut       TVarChar
             , AccounterName      TVarChar
             , INN                TVarChar
             , NumberVAT          TVarChar
             , BankAccount        TVarChar
             , Phone              TVarChar
             , BankName           TVarChar
             , MFO                TVarChar
  
             , PartnerMedical_FullName         TVarChar
             , PartnerMedical_JuridicalAddress TVarChar
             , PartnerMedical_OKPO             TVarChar
             , PartnerMedical_Phone            TVarChar

             , PartnerMedical_BankAccount      TVarChar
             , PartnerMedical_BankName         TVarChar
             , PartnerMedical_MFO              TVarChar
             , PartnerMedical_MainName         TVarChar
             , PartnerMedical_MainName_Cut     TVarChar
             , ContractId          Integer
             , ContractName        TVarChar
             , Contract_StartDate              TDateTime
             , Contract_SigningDate            TDateTime
             
             , DepartmentId                 Integer
             , Department_FullName          TVarChar
             , Department_JuridicalAddress  TVarChar
             , Department_OKPO              TVarChar
             , Department_Phone             TVarChar
             , Department_BankAccount       TVarChar
             , Department_BankName          TVarChar
             , Department_MFO               TVarChar
             , Department_MainName          TVarChar
             , Department_MainName_Cut      TVarChar
             , ContractId_Department        Integer
             , ContractName_Department      TVarChar
             , Contract_StartDate_Department   TDateTime
             , Contract_SigningDate_Department TDateTime

             , MedicSPName                        TVarChar
             , InvNumberSP                        TVarChar
             , OperDateSP                         TDateTime
             , OperDate                           TDateTime
  
             , InvNumber_Invoice      TVarChar
             , InvNumber_Invoice_Full TVarChar
             , OperDate_Invoice       TDateTime
             , TotalSumm_Invoice      TFloat

             , isPrintLast       Boolean

             , TotalSumm_Check TFloat
             , InsertName_Check TVarChar
             , InsertDate_Check TDateTime
             , NDS TFloat
)
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbStartYear TDateTime;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Movement_Income());
    vbUserId:= lpGetUserBySession (inSession);
    
    IF EXISTS (SELECT 1 FROM ObjectLink_UserRole_View  WHERE UserId = vbUserId AND RoleId = zc_Enum_Role_DirectorPartner())
    THEN
       inUnitId := zc_DirectorPartner_UnitID();
    END IF;

    IF inJuridicalMedicId <> 0 AND inStartDate >= '01.04.2019' THEN
    -- Результат
    RETURN QUERY
        -- результат
        SELECT tmp.*
        FROM gpReport_Check_SP_01042019 (inStartDate          := inStartDate
                                       , inEndDate            := inEndDate          
                                       , inJuridicalId        := inJuridicalId      
                                       , inUnitId             := inUnitId           
                                       , inHospitalId         := inHospitalId       
                                       , inJuridicalMedicId   := inJuridicalMedicId 
                                       , inMedicalProgramSPId := inMedicalProgramSPId
                                       , inSession            := inSession          
                                         ) AS tmp;
    ELSE 
    RETURN QUERY
        -- результат
        SELECT tmp.*
        FROM gpReport_Check_SP_old (inStartDate          := inStartDate
                                  , inEndDate            := inEndDate          
                                  , inJuridicalId        := inJuridicalId      
                                  , inUnitId             := inUnitId           
                                  , inHospitalId         := inHospitalId    
                                  , inMedicalProgramSPId := inMedicalProgramSPId
                                  , inSession            := inSession          
                                    ) AS tmp;
    END IF;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Воробкало А.А.
 26.04.19         *
*/

-- тест
-- SELECT * FROM gpReport_Check_SP (inStartDate:= '01.04.2017',inEndDate:= '15.04.2017', inJuridicalId:= 0, inUnitId:= 0, inHospitalId:= 0, inSession := '3');
-- select * from gpReport_Check_SP(inStartDate := ('01.01.2017')::TDateTime , inEndDate := ('31.12.2017')::TDateTime , inJuridicalId := 0 , inUnitId := 0 , inHospitalId := 0 ,  inSession := '3');
-- select * from gpReport_Check_SP(inStartDate := ('01.03.2018')::TDateTime , inEndDate := ('15.03.2018')::TDateTime , inJuridicalId := 393052 , inUnitId := 0 , inHospitalId := 4474509 ,  inSession := '3');
-- select * from gpReport_Check_SP22(inStartDate := ('01.09.2018')::TDateTime , inEndDate := ('09.09.2018')::TDateTime, inJuridicalId := 393054 , inUnitId := 0 , inHospitalId := 3751525 ,  inSession := '3');
-- select * from gpReport_Check_SP(inStartDate := ('01.02.2011')::TDateTime , inEndDate := ('02.02.2011')::TDateTime , inJuridicalId := 0 , inUnitId := 0 , inHospitalId := 0 , inJuridicalMedicId := 10959824 ,  inSession := '3');


select * from gpReport_Check_SP(inStartDate := ('01.10.2021')::TDateTime , inEndDate := ('05.10.2021')::TDateTime , inJuridicalId := 0 , inUnitId := 0 , inHospitalId := 0 , inJuridicalMedicId := 0 , inMedicalProgramSPId := 18076882 ,  inSession := '3');