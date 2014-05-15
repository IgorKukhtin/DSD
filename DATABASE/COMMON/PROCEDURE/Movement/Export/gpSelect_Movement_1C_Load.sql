-- Function: gpSelect_Movement_1C_Load()

DROP FUNCTION IF EXISTS gpSelect_Movement_1C_Load (TDateTime, TDateTime, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_1C_Load(
    IN inStartDate      TDateTime , --
    IN inEndDate        TDateTime , --
    IN inInfoMoneyId    Integer   ,
    IN inPaidKindId     Integer   ,
    IN inSession        TVarChar    -- сессия пользователя
)
RETURNS TABLE (UnitId TVarChar,  VidDoc TVarChar, InvNumber TVarChar, OperDate TVarChar, ClientCode TVarChar, ClientName TVarChar,
               GoodsCode  TVarChar, GoodsName TVarChar, OperCount TVarChar, OperPrice TVarChar, 
               Tax TVarChar, Suma TVarChar, PDV TVarChar, SumaPDV TVarChar,
               ClientINN TVarChar, ClientOKPO TVarChar, CLIENTKIND TVarChar, 
               InvNalog TVarChar, BillId TVarChar, EKSPCODE TVarChar, EXPName TVarChar,            
               GoodsId TVarChar, PackId TVarChar, PackName TVarChar, 
               Doc1Date TVarChar, Doc1Number TVarChar, Doc2Date TVarChar, Doc2Number TVarChar)
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Select_Movement_Tax());
     vbUserId:= inSession;

     --
     RETURN QUERY
     SELECT
             CASE Movement.DescId
                  WHEN zc_Movement_Sale() THEN MovementLinkObject_From.ObjectId
                  WHEN zc_Movement_ReturnIn() THEN MovementLinkObject_To.ObjectId
             END::TVarChar                                           AS UnitId
           , CASE Movement.DescId
                  WHEN zc_Movement_Sale() THEN 2
                  WHEN zc_Movement_ReturnIn() THEN 4
             END::TVarChar                                           AS VidDoc
           , Movement.InvNumber				             AS InvNumber
           , to_char(Movement.OperDate, 'DD.MM.YYYY')::TVarChar	     AS OperDate

           , CASE Movement.DescId
                  WHEN zc_Movement_Sale() THEN Object_To.Id
                  WHEN zc_Movement_ReturnIn() THEN Object_From.Id
             END::TVarChar                                           AS ClientCode

           , CASE Movement.DescId
                  WHEN zc_Movement_Sale() THEN Object_To.ValueData
                  WHEN zc_Movement_ReturnIn() THEN Object_From.ValueData
             END::TVarChar                                           AS ClientName

           , Object_GoodsByGoodsKind_View.Id::TVarChar               AS GoodsCode
           , Object_GoodsByGoodsKind_View.GoodsName                  AS GoodsName
             
           , MIMaster.Amount::TVarChar                               AS OperCount
           , MIFloat_Price.ValueData::TVarChar                       AS OperPrice
           , '0'::TVarChar                                           AS Tax
           , round((MIMaster.Amount*MIFloat_Price.ValueData), 4)::TVarChar     AS Summa
           , (round( MIMaster.Amount * MIFloat_Price.ValueData * 
                      (100 + COALESCE (MovementFloat_VATPercent.ValueData, 0))/100, 4) 
                       - round((MIMaster.Amount*MIFloat_Price.ValueData), 4))::TVarChar
                                                                       AS PDV
           , (round( MIMaster.Amount * MIFloat_Price.ValueData * 
                      (100 + COALESCE (MovementFloat_VATPercent.ValueData, 0))/100, 4))::TVarChar       
                                                                      AS SummaPDV

           , ObjectHistoryString_JuridicalDetails_INN.ValueData      AS ClientINN
           , ObjectHistoryString_JuridicalDetails_OKPO.ValueData     AS ClientOKPO
           , CASE Object_Contract_View.InfoMoneyId                   
                  WHEN zc_Enum_InfoMoney_30101()  THEN 1
                  ELSE 2    
             END::TVarChar                                           AS CLIENTKIND
           , Movement_DocumentMaster.InvNumber                       AS InvNalog
           , Movement.Id::TVarChar                                   AS BillId
           , ''::TVarChar                                            AS EKSPCODE
           , ''::TVarChar                                            AS EKSPName
           , Object_GoodsByGoodsKind_View.GoodsId::TVarChar          AS GoodsId
           , Object_GoodsByGoodsKind_View.GoodsKindId::TVarChar      AS PackId
           , Object_GoodsByGoodsKind_View.GoodsKindName              AS PackName 
           , ''::TVarChar                                            AS Doc1Date
           , ''::TVarChar                                            AS Doc1Number
           , ''::TVarChar                                            AS Doc2Date
           , ''::TVarChar                                            AS Doc2Number
  
       FROM Movement
            LEFT JOIN MovementLinkObject AS MovementLinkObject_Contract
                                         ON MovementLinkObject_Contract.MovementId = Movement.Id
                                        AND MovementLinkObject_Contract.DescId IN ( zc_MovementLinkObject_Contract(), zc_MovementLinkObject_ContractTo())
            LEFT JOIN Object_Contract_View ON Object_Contract_View.ContractId = MovementLinkObject_Contract.ObjectId

            LEFT JOIN MovementFloat AS MovementFloat_VATPercent
                                   ON MovementFloat_VATPercent.MovementId = Movement.Id
                                  AND MovementFloat_VATPercent.DescId = zc_MovementFloat_VATPercent()

            LEFT JOIN MovementLinkMovement AS MovementLinkMovement_Master
                                           ON MovementLinkMovement_Master.MovementId = Movement.Id
                                          AND MovementLinkMovement_Master.DescId = zc_MovementLinkMovement_Master()
            LEFT JOIN Movement AS Movement_DocumentMaster ON Movement_DocumentMaster.Id = MovementLinkMovement_Master.MovementChildId
                                                         AND Movement_DocumentMaster.StatusId <> zc_Enum_Status_Erased()

            LEFT JOIN MovementItem AS MIMaster ON MIMaster.MovementId = Movement.Id AND MIMaster.DescId = zc_MI_Master()

            LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                             ON MILinkObject_GoodsKind.MovementItemId = MIMaster.Id
                                            AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()

            LEFT JOIN Object_GoodsByGoodsKind_View ON Object_GoodsByGoodsKind_View.GoodsId = MIMaster.ObjectId
                                                  AND Object_GoodsByGoodsKind_View.GoodsKindId = MILinkObject_GoodsKind.ObjectId
  
            LEFT JOIN MovementItemFloat AS MIFloat_Price
                                        ON MIFloat_Price.MovementItemId = MIMaster.Id
                                       AND MIFloat_Price.DescId = zc_MIFloat_Price()

            LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                         ON MovementLinkObject_To.MovementId = Movement.Id
                                        AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()

            LEFT JOIN Object AS Object_To ON 
                      Object_To.Id =  MovementLinkObject_To.ObjectId

            LEFT JOIN ObjectLink AS ObjectLink_Partner_Juridical_To
                                 ON ObjectLink_Partner_Juridical_To.ObjectId = MovementLinkObject_To.ObjectId
                                AND ObjectLink_Partner_Juridical_To.DescId = zc_ObjectLink_Partner_Juridical()

            LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                         ON MovementLinkObject_From.MovementId = Movement.Id
                                        AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()

            LEFT JOIN Object AS Object_From ON 
                      Object_From.Id =  MovementLinkObject_From.ObjectId

            LEFT JOIN ObjectLink AS ObjectLink_Partner_Juridical_From
                                 ON ObjectLink_Partner_Juridical_From.ObjectId = MovementLinkObject_From.ObjectId
                                AND ObjectLink_Partner_Juridical_From.DescId = zc_ObjectLink_Partner_Juridical()

            LEFT JOIN Object AS Object_Juridical ON 
                      Object_Juridical.Id =  COALESCE(ObjectLink_Partner_Juridical_From.ChildObjectId, ObjectLink_Partner_Juridical_To.ChildObjectId)

            LEFT JOIN MovementFloat AS MovementFloat_TotalSummMVAT
                                    ON MovementFloat_TotalSummMVAT.MovementId =  Movement.Id
                                   AND MovementFloat_TotalSummMVAT.DescId = zc_MovementFloat_TotalSummMVAT()

            LEFT JOIN MovementFloat AS MovementFloat_TotalSummPVAT
                                    ON MovementFloat_TotalSummPVAT.MovementId =  Movement.Id
                                   AND MovementFloat_TotalSummPVAT.DescId = zc_MovementFloat_TotalSummPVAT()

            LEFT JOIN ObjectHistory AS ObjectHistory_JuridicalDetails 
                   ON ObjectHistory_JuridicalDetails.ObjectId = Object_Juridical.Id
                  AND ObjectHistory_JuridicalDetails.DescId = zc_ObjectHistory_JuridicalDetails()
                  AND Movement.OperDate BETWEEN ObjectHistory_JuridicalDetails.StartDate AND ObjectHistory_JuridicalDetails.EndDate  
           LEFT JOIN ObjectHistoryString AS ObjectHistoryString_JuridicalDetails_FullName
                  ON ObjectHistoryString_JuridicalDetails_FullName.ObjectHistoryId = ObjectHistory_JuridicalDetails.Id
                 AND ObjectHistoryString_JuridicalDetails_FullName.DescId = zc_ObjectHistoryString_JuridicalDetails_FullName()
           LEFT JOIN ObjectHistoryString AS ObjectHistoryString_JuridicalDetails_INN
                  ON ObjectHistoryString_JuridicalDetails_INN.ObjectHistoryId = ObjectHistory_JuridicalDetails.Id
                 AND ObjectHistoryString_JuridicalDetails_INN.DescId = zc_ObjectHistoryString_JuridicalDetails_INN()
           LEFT JOIN ObjectHistoryString AS ObjectHistoryString_JuridicalDetails_OKPO
                  ON ObjectHistoryString_JuridicalDetails_OKPO.ObjectHistoryId = ObjectHistory_JuridicalDetails.Id
                 AND ObjectHistoryString_JuridicalDetails_OKPO.DescId = zc_ObjectHistoryString_JuridicalDetails_OKPO()


      WHERE Movement.OperDate BETWEEN inStartDate AND inEndDate 
        AND Movement.DescId in (zc_Movement_Sale(), zc_Movement_ReturnIn()) 
        AND Movement.StatusId = zc_Enum_Status_Complete();



END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Movement_1C_Load (TDateTime, TDateTime, Integer, Integer, TVarChar) OWNER TO postgres;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 14.05.14                         *
*/

-- тест
-- SELECT * FROM gpSelect_Movement_Tax (inStartDate:= '30.01.2013', inEndDate:= '02.02.2014', inIsRegisterDate:=FALSE, inIsErased :=TRUE, inSession:= '2')