-- Function: gpReport_Sale_OrderExternal_List()


DROP FUNCTION IF EXISTS gpReport_Sale_OrderExternal_List (TDateTime, TDateTime, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpReport_Sale_OrderExternal_List (TDateTime, TDateTime, Integer, Boolean, Boolean, TVarChar);


CREATE OR REPLACE FUNCTION gpReport_Sale_OrderExternal_List(
    IN inStartDate   TDateTime , --
    IN inEndDate     TDateTime , --
    IN inUnitId      Integer   , -- ������
    IN inisSale      Boolean   ,
    IN inisNoSale    Boolean   ,
    IN inSession     TVarChar    -- ������ ������������
)
RETURNS TABLE (MovementId_Order Integer, InvNumber TVarChar, OperDate TDateTime, OperDatePartner TDateTime
             , FromName TVarChar, ToName TVarChar
             , TotalSummPVAT TFloat, TotalSumm TFloat
             , TotalCountKg TFloat, TotalCountSh TFloat, TotalCount TFloat, TotalCountSecond TFloat

             , Sale_InvNumber TVarChar, Sale_OperDate TDateTime, Sale_OperDatePartner TDateTime
             , Sale_FromName TVarChar, Sale_ToName TVarChar
             , Sale_TotalSummPVAT TFloat, Sale_TotalSumm TFloat
             , Sale_TotalCountKg TFloat, Sale_TotalCountSh TFloat, Sale_TotalCount TFloat, Sale_TotalCountPartner TFloat
             , Sale_InvNumberOrder TVarChar
             )
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId:= lpGetUserBySession (inSession);

     -- ���������
     RETURN QUERY 
   WITH tmpOrderExternal AS ( SELECT Movement.Id
                                , Movement.InvNumber                             AS InvNumber
                                , Movement.OperDate                              AS OperDate
                                , MovementDate_OperDatePartner.ValueData         AS OperDatePartner
                                , Object_From.Id                                 AS FromId
                                , Object_From.ValueData                          AS FromName
                                , Object_To.Id                                   AS ToId
                                , Object_To.ValueData                            AS ToName

                                , MovementFloat_TotalSummPVAT.ValueData          AS TotalSummPVAT
                                , MovementFloat_TotalSumm.ValueData              AS TotalSumm
                                , MovementFloat_TotalCountKg.ValueData           AS TotalCountKg
                                , MovementFloat_TotalCountSh.ValueData           AS TotalCountSh
                                , MovementFloat_TotalCount.ValueData             AS TotalCount
                                , MovementFloat_TotalCountSecond.ValueData       AS TotalCountSecond

                            FROM Movement 
                                 LEFT JOIN MovementDate AS MovementDate_OperDatePartner
                                                        ON MovementDate_OperDatePartner.MovementId =  Movement.Id
                                                       AND MovementDate_OperDatePartner.DescId = zc_MovementDate_OperDatePartner()

                                 LEFT JOIN MovementFloat AS MovementFloat_TotalCount
                                                         ON MovementFloat_TotalCount.MovementId =  Movement.Id
                                                        AND MovementFloat_TotalCount.DescId = zc_MovementFloat_TotalCount()

                                 LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                                              ON MovementLinkObject_From.MovementId = Movement.Id
                                                             AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
                                 LEFT JOIN Object AS Object_From ON Object_From.Id = MovementLinkObject_From.ObjectId

                                 LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                                              ON MovementLinkObject_To.MovementId = Movement.Id
                                                             AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
                                 LEFT JOIN Object AS Object_To ON Object_To.Id = MovementLinkObject_To.ObjectId

                                 LEFT JOIN MovementFloat AS MovementFloat_TotalCountSh
                                                         ON MovementFloat_TotalCountSh.MovementId =  Movement.Id
                                                        AND MovementFloat_TotalCountSh.DescId = zc_MovementFloat_TotalCountSh()
                                 LEFT JOIN MovementFloat AS MovementFloat_TotalCountKg
                                                         ON MovementFloat_TotalCountKg.MovementId =  Movement.Id
                                                        AND MovementFloat_TotalCountKg.DescId = zc_MovementFloat_TotalCountKg()
                                 LEFT JOIN MovementFloat AS MovementFloat_TotalCountSecond
                                                         ON MovementFloat_TotalCountSecond.MovementId =  Movement.Id
                                                        AND MovementFloat_TotalCountSecond.DescId = zc_MovementFloat_TotalCountSecond()

                                 LEFT JOIN MovementFloat AS MovementFloat_TotalSummPVAT
                                                         ON MovementFloat_TotalSummPVAT.MovementId =  Movement.Id
                                                        AND MovementFloat_TotalSummPVAT.DescId = zc_MovementFloat_TotalSummPVAT()
                                 LEFT JOIN MovementFloat AS MovementFloat_TotalSumm
                                                         ON MovementFloat_TotalSumm.MovementId =  Movement.Id
                                                        AND MovementFloat_TotalSumm.DescId = zc_MovementFloat_TotalSumm()
        
                                 LEFT JOIN MovementLinkMovement AS MovementLinkMovement_Order
                                                                ON MovementLinkMovement_Order.MovementId = Movement.Id
                                                               AND MovementLinkMovement_Order.DescId = zc_MovementLinkMovement_Order()
         
                            WHERE Movement.DescId = zc_Movement_OrderExternal()
                              AND Movement.OperDate BETWEEN inStartDate AND inEndDate   
                              AND Movement.StatusId = zc_Enum_Status_Complete()
                              AND COALESCE (Object_From.DescId, 0) <> zc_Object_Unit()
                              AND (MovementLinkObject_To.ObjectId = inUnitId OR inUnitId = 0) 
                          )

   , tmpSale AS (SELECT Movement.Id
                      , Movement.InvNumber                             AS InvNumber
                      , Movement.OperDate                              AS OperDate
                      , MovementDate_OperDatePartner.ValueData         AS OperDatePartner
                      
                      , MovementFloat_TotalCount.ValueData             AS TotalCount
                      , MovementFloat_TotalCountPartner.ValueData      AS TotalCountPartner
                      , MovementFloat_TotalCountSh.ValueData           AS TotalCountSh
                      , MovementFloat_TotalCountKg.ValueData           AS TotalCountKg
           
                      , MovementFloat_TotalSummPVAT.ValueData          AS TotalSummPVAT
                      , MovementFloat_TotalSumm.ValueData              AS TotalSumm
                     
                      , MovementLinkMovement_Order.MovementChildId     AS MovementId_Order
                      , MovementString_InvNumberOrder.ValueData        AS InvNumberOrder
                      , Object_From.Id                                 AS FromId
                      , Object_From.ValueData                          AS FromName
                      , Object_To.Id                                   AS ToId
                      , Object_To.ValueData                            AS ToName
                     
                 FROM ( SELECT MovementLinkMovement_Order.MovementId
                        FROM tmpOrderExternal 
                        INNER JOIN MovementLinkMovement AS MovementLinkMovement_Order 
                                                        ON MovementLinkMovement_Order.MovementChildId = tmpOrderExternal.Id
                       ) AS tmpMovementSale
                      INNER JOIN Movement ON Movement.Id = tmpMovementSale.MovementId
                      LEFT JOIN MovementDate AS MovementDate_OperDatePartner
                                             ON MovementDate_OperDatePartner.MovementId =  Movement.Id
                                            AND MovementDate_OperDatePartner.DescId = zc_MovementDate_OperDatePartner()
             
                      LEFT JOIN MovementFloat AS MovementFloat_TotalCount
                                              ON MovementFloat_TotalCount.MovementId =  Movement.Id
                                             AND MovementFloat_TotalCount.DescId = zc_MovementFloat_TotalCount()
                      LEFT JOIN MovementFloat AS MovementFloat_TotalCountPartner
                                              ON MovementFloat_TotalCountPartner.MovementId =  Movement.Id
                                             AND MovementFloat_TotalCountPartner.DescId = zc_MovementFloat_TotalCountPartner()
                      LEFT JOIN MovementFloat AS MovementFloat_TotalCountSh
                                              ON MovementFloat_TotalCountSh.MovementId =  Movement.Id
                                             AND MovementFloat_TotalCountSh.DescId = zc_MovementFloat_TotalCountSh()
                      LEFT JOIN MovementFloat AS MovementFloat_TotalCountKg
                                              ON MovementFloat_TotalCountKg.MovementId =  Movement.Id
                                             AND MovementFloat_TotalCountKg.DescId = zc_MovementFloat_TotalCountKg()
          
                      LEFT JOIN MovementFloat AS MovementFloat_TotalSummPVAT
                                              ON MovementFloat_TotalSummPVAT.MovementId =  Movement.Id
                                             AND MovementFloat_TotalSummPVAT.DescId = zc_MovementFloat_TotalSummPVAT()
                      
                      LEFT JOIN MovementFloat AS MovementFloat_TotalSumm
                                              ON MovementFloat_TotalSumm.MovementId =  Movement.Id
                                             AND MovementFloat_TotalSumm.DescId = zc_MovementFloat_TotalSumm()
                      
                      LEFT JOIN MovementString AS MovementString_InvNumberOrder
                                               ON MovementString_InvNumberOrder.MovementId =  Movement.Id
                                              AND MovementString_InvNumberOrder.DescId = zc_MovementString_InvNumberOrder()
          
                      LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                                   ON MovementLinkObject_From.MovementId = Movement.Id
                                                  AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
                      LEFT JOIN Object AS Object_From ON Object_From.Id = MovementLinkObject_From.ObjectId
          
                      LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                                   ON MovementLinkObject_To.MovementId = Movement.Id
                                                  AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
                      LEFT JOIN Object AS Object_To ON Object_To.Id = MovementLinkObject_To.ObjectId
          
                      LEFT JOIN MovementLinkMovement AS MovementLinkMovement_Sale
                                                     ON MovementLinkMovement_Sale.MovementId = Movement.Id 
                                                    AND MovementLinkMovement_Sale.DescId = zc_MovementLinkMovement_Sale()
          
                      LEFT JOIN MovementLinkMovement AS MovementLinkMovement_Order
                                                     ON MovementLinkMovement_Order.MovementId = Movement.Id 
                                                    AND MovementLinkMovement_Order.DescId = zc_MovementLinkMovement_Order()
          
                 WHERE Movement.DescId = zc_Movement_Sale() 
                   AND Movement.StatusId = zc_Enum_Status_Complete()
                   AND (MovementLinkObject_From.ObjectId = inUnitId OR inUnitId = 0) 
                   )
                             
   , tmpList AS (SELECT tmpOrderExternal.Id AS MovementId_Order 
                      , tmpOrderExternal.InvNumber
                      , tmpOrderExternal.OperDate
                      , tmpOrderExternal.OperDatePartner
                      , tmpOrderExternal.FromName
                      , tmpOrderExternal.ToName
                      
                      , tmpOrderExternal.TotalCount
                      , tmpOrderExternal.TotalCountSecond
                      , tmpOrderExternal.TotalCountKg
                      , tmpOrderExternal.TotalCountSh
                      , tmpOrderExternal.TotalSummPVAT
                      , tmpOrderExternal.TotalSumm
                      
                                         
                      , tmpSale.InvNumber                   AS Sale_InvNumber
                      , tmpSale.OperDate                    AS Sale_OperDate
                      , tmpSale.OperDatePartner             AS Sale_OperDatePartner
                      , tmpSale.FromName                    AS Sale_FromName
                      , tmpSale.ToName                      AS Sale_ToName

                      , tmpSale.TotalCount                  AS Sale_TotalCount
                      , tmpSale.TotalCountPartner           AS Sale_TotalCountPartner
                      , tmpSale.TotalCountSh                AS Sale_TotalCountSh    
                      , tmpSale.TotalCountKg                AS Sale_TotalCountKg
                      , tmpSale.TotalSummPVAT               AS Sale_TotalSummPVAT
                      , tmpSale.TotalSumm                   AS Sale_TotalSumm

                      , tmpSale.InvNumberOrder              AS Sale_InvNumberOrder
                      
                 FROM tmpOrderExternal
                      Left JOIN tmpSale ON tmpSale.MovementId_Order = tmpOrderExternal.Id 
                 )

                 SELECT tmpList.MovementId_Order
                      , tmpList.InvNumber
                      , tmpList.OperDate
                      , tmpList.OperDatePartner
                      , tmpList.FromName
                      , tmpList.ToName

                      , tmpList.TotalSummPVAT
                      , tmpList.TotalSumm
                      , tmpList.TotalCountKg
                      , tmpList.TotalCountSh
                      , tmpList.TotalCount
                      , tmpList.TotalCountSecond
                                         
                      , tmpList.Sale_InvNumber
                      , tmpList.Sale_OperDate
                      , tmpList.Sale_OperDatePartner
                      , tmpList.Sale_FromName
                      , tmpList.Sale_ToName

                      , tmpList.Sale_TotalSummPVAT
                      , tmpList.Sale_TotalSumm
                      , tmpList.Sale_TotalCountKg
                      , tmpList.Sale_TotalCountSh    
                      , tmpList.Sale_TotalCount
                      , tmpList.Sale_TotalCountPartner
       
                      , tmpList.Sale_InvNumberOrder
        
                 FROM tmpList
                 WHERE ( COALESCE (tmpList.Sale_InvNumber,'') <> '' AND inisSale = True)
                    OR ( COALESCE (tmpList.Sale_InvNumber,'') = '' AND inisNoSale = True)
                    OR (inisSale = False and inisNoSale = False)
    
        
      ;
  
END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 04.01.16         *
*/

-- ����
 --SELECT * FROM gpReport_Sale_OrderExternal_List (inStartDate:= '01.08.2015', inEndDate:= '01.08.2015', inUnitId:=0 ,inSession:= zfCalc_UserAdmin())
