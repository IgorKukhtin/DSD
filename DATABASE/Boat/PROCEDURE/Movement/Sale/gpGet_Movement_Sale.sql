-- Function: gpGet_Movement_Sale()

DROP FUNCTION IF EXISTS gpGet_Movement_Sale (Integer, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Movement_Sale(
    IN inMovementId        Integer  , -- ключ Документа
    IN inOperDate          TDateTime ,
    IN inSession           TVarChar   -- сессия пользователя
)
RETURNS TABLE (Id Integer, InvNumber TVarChar
             , OperDate TDateTime
             , StatusCode Integer, StatusName TVarChar
             , MovementId_Parent Integer, InvNumber_Parent TVarChar, Comment_parent TVarChar
             , FromId Integer, FromName TVarChar
             , ToId Integer, ToName TVarChar
             , PriceWithVAT Boolean
             , VATPercent TFloat
             , Comment TVarChar
             , InsertId Integer, InsertName TVarChar, InsertDate TDateTime
             , Value_TaxKind TFloat, TaxKindId Integer, TaxKindName TVarChar, TaxKindName_info TVarChar
              )
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN

     -- проверка прав пользователя на вызов процедуры
     -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_Get_Movement_Sale());
     vbUserId := inSession;

     IF COALESCE (inMovementId, 0) = 0
     THEN
     RETURN QUERY
         SELECT
               0                         AS Id
             , CAST (NEXTVAL ('movement_Sale_seq') AS TVarChar) AS InvNumber
             , CURRENT_DATE :: TDateTime AS OperDate     --CURRENT_DATE
             , Object_Status.Code        AS StatusCode
             , Object_Status.Name        AS StatusName
             , 0                         AS MovementId_Parent
             , CAST ('' AS TVarChar)     AS InvNumber_Parent
             , CAST ('' AS TVarChar)     AS Comment_parent
             , 0                         AS FromId
             , CAST ('' AS TVarChar)     AS FromName
             , 0                         AS ToId
             , CAST ('' AS TVarChar)     AS ToName
             , CAST (False as Boolean)   AS PriceWithVAT
             , ObjectFloat_TaxKind_Value.ValueData :: TFloat AS VATPercent
             , CAST ('' AS TVarChar)     AS Comment
             , Object_Insert.Id                AS InsertId
             , Object_Insert.ValueData         AS InsertName
             , CURRENT_TIMESTAMP  ::TDateTime  AS InsertDate

             , CAST (0 as TFloat)        AS Value_TaxKind
             , 0                         AS TaxKindId
             , CAST ('' as TVarChar)     AS TaxKindName
             , CAST ('' as TVarChar)     AS TaxKindName_info

             , CAST (0 as TFloat)        AS VATPercent_order
             , CAST (0 as TFloat)        AS DiscountTax     
             , CAST (0 as TFloat)        AS DiscountNextTax 
             , CAST (0 as TFloat)        AS SummTax         
             , CAST (0 as TFloat)        AS SummReal        
             , CAST (0 as TFloat)        AS SummReal_real   
             , CAST (0 as TFloat)        AS Basis_summ1_orig  
             , CAST (0 as TFloat)        AS Basis_summ2_orig  
             , CAST (0 as TFloat)        AS Basis_summ_orig   
             , CAST (0 as TFloat)        AS SummDiscount1     
             , CAST (0 as TFloat)        AS SummDiscount2     
             , CAST (0 as TFloat)        AS SummDiscount3     
             , CAST (0 as TFloat)        AS SummDiscount_total
             , CAST (0 as TFloat)        AS Basis_summ        
             , CAST (0 as TFloat)        AS TransportSumm_load
             , CAST (0 as TFloat)        AS Basis_summ_transport
             , CAST (0 as TFloat)        AS BasisWVAT_summ_transport

          FROM lfGet_Object_Status(zc_Enum_Status_UnComplete()) AS Object_Status
               LEFT JOIN ObjectFloat AS ObjectFloat_TaxKind_Value
                                     ON ObjectFloat_TaxKind_Value.ObjectId = zc_Enum_TaxKind_Basis()
                                    AND ObjectFloat_TaxKind_Value.DescId = zc_ObjectFloat_TaxKind_Value()
               LEFT JOIN Object AS Object_Insert ON Object_Insert.Id = vbUserId
          ;

     ELSE

     RETURN QUERY

        SELECT 
            Movement_Sale.Id
          , Movement_Sale.InvNumber
          , Movement_Sale.OperDate      AS OperDate
          , Object_Status.ObjectCode    AS StatusCode
          , Object_Status.ValueData     AS StatusName
          , Movement_Parent.Id               AS MovementId_Parent
          , zfCalc_InvNumber_isErased ('', Movement_Parent.InvNumber, Movement_Parent.OperDate, Movement_Parent.StatusId) AS InvNumber_Parent
          , MovementString_Comment_parent.ValueData ::TVarChar AS Comment_parent
          , Object_From.Id              AS FromId
          , Object_From.ValueData       AS FromName
          , Object_To.Id                AS ToId      
          , Object_To.ValueData         AS ToName


          , COALESCE (MovementBoolean_PriceWithVAT.ValueData, FALSE) :: Boolean AS PriceWithVAT
          , MovementFloat_VATPercent.ValueData        AS VATPercent
          
          , COALESCE (MovementString_Comment.ValueData,'') :: TVarChar AS Comment

          , Object_Insert.Id                     AS InsertId
          , Object_Insert.ValueData              AS InsertName
          , MovementDate_Insert.ValueData        AS InsertDate

          , ObjectFloat_TaxKind_Value.ValueData          AS Value_TaxKind
          , Object_TaxKind.Id                            AS TaxKindId
          , Object_TaxKind.ValueData                     AS TaxKindName
          , ObjectString_TaxKind_Info.ValueData          AS TaxKindName_info
          
          -- данные из Заказа клиента - лодки
          , tmpParent_Params.VATPercent      ::TFLoat AS VATPercent_order
          , tmpParent_Params.DiscountTax     ::TFLoat
          , tmpParent_Params.DiscountNextTax ::TFLoat
            -- Cумма откорректированной скидки, без НДС
          , tmpParent_Params.SummTax         :: TFLoat
            -- ИТОГО откорректированная сумма, с учетом всех скидок, без Транспорта, Сумма продажи без НДС
          , tmpParent_Params.SummReal        :: TFloat
          , tmpParent_Params.SummReal_real   :: TFLoat
            -- ИТОГО Без скидки, Цена продажи базовой модели лодки, без НДС
          , tmpParent_Params.Basis_summ1_orig        ::TFloat
            -- ИТОГО Без скидки, Сумма опций, без НДС
          , tmpParent_Params.Basis_summ2_orig         ::TFloat
            -- ИТОГО Без скидки, Цена продажи базовой модели лодки + Сумма всех опций, без НДС
          , tmpParent_Params.Basis_summ_orig          ::TFloat
            -- ИТОГО Сумма Скидки - без НДС
          , tmpParent_Params.SummDiscount1            ::TFloat
          , tmpParent_Params.SummDiscount2            ::TFloat
          , tmpParent_Params.SummDiscount3            ::TFloat
          , tmpParent_Params.SummDiscount_total       ::TFloat
            -- ИТОГО Сумма продажи без НДС - со ВСЕМИ Скидками (Basis+options)
          , tmpParent_Params.Basis_summ               ::TFLoat
           -- Сумма транспорт с сайта
          , tmpParent_Params.TransportSumm_load       ::TFLoat
           -- ИТОГО Сумма продажи без НДС - со ВСЕМИ Скидками (Basis+options) + TRANSPORT
          , tmpParent_Params.Basis_summ_transport     ::TFLoat
            -- ИТОГО Сумма продажи с НДС - со ВСЕМИ Скидками (Basis+options) + TRANSPORT
          , tmpParent_Params.BasisWVAT_summ_transport ::TFLoat
        FROM Movement AS Movement_Sale 
            LEFT JOIN Movement AS Movement_Parent ON Movement_Parent.Id = Movement_Sale.ParentId
            LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement_Sale.StatusId
 
            LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                         ON MovementLinkObject_To.MovementId = Movement_Sale.Id
                                        AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
            LEFT JOIN Object AS Object_To ON Object_To.Id = MovementLinkObject_To.ObjectId 

            LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                         ON MovementLinkObject_From.MovementId = Movement_Sale.Id
                                        AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
            LEFT JOIN Object AS Object_From ON Object_From.Id = MovementLinkObject_From.ObjectId

            LEFT JOIN MovementFloat AS MovementFloat_VATPercent
                                    ON MovementFloat_VATPercent.MovementId = Movement_Sale.Id
                                   AND MovementFloat_VATPercent.DescId = zc_MovementFloat_VATPercent()

            LEFT JOIN MovementBoolean AS MovementBoolean_PriceWithVAT
                                      ON MovementBoolean_PriceWithVAT.MovementId = Movement_Sale.Id
                                     AND MovementBoolean_PriceWithVAT.DescId = zc_MovementBoolean_PriceWithVAT()

            LEFT JOIN MovementString AS MovementString_Comment
                                     ON MovementString_Comment.MovementId = Movement_Sale.Id
                                    AND MovementString_Comment.DescId = zc_MovementString_Comment()

            LEFT JOIN MovementDate AS MovementDate_Insert
                                   ON MovementDate_Insert.MovementId = Movement_Sale.Id
                                  AND MovementDate_Insert.DescId = zc_MovementDate_Insert()
            LEFT JOIN MovementLinkObject AS MLO_Insert
                                         ON MLO_Insert.MovementId = Movement_Sale.Id
                                        AND MLO_Insert.DescId = zc_MovementLinkObject_Insert()
            LEFT JOIN Object AS Object_Insert ON Object_Insert.Id = MLO_Insert.ObjectId

            LEFT JOIN MovementString AS MovementString_Comment_parent
                                     ON MovementString_Comment_parent.MovementId = Movement_Parent.Id
                                    AND MovementString_Comment_parent.DescId = zc_MovementString_Comment()

            --
            LEFT JOIN ObjectLink AS ObjectLink_TaxKind
                                 ON ObjectLink_TaxKind.ObjectId = Object_To.Id
                                AND ObjectLink_TaxKind.DescId = zc_ObjectLink_Client_TaxKind()
            LEFT JOIN Object AS Object_TaxKind ON Object_TaxKind.Id = ObjectLink_TaxKind.ChildObjectId
                                
            LEFT JOIN ObjectFloat AS ObjectFloat_TaxKind_Value
                                  ON ObjectFloat_TaxKind_Value.ObjectId = ObjectLink_TaxKind.ChildObjectId 
                                 AND ObjectFloat_TaxKind_Value.DescId = zc_ObjectFloat_TaxKind_Value()   
            LEFT JOIN ObjectString AS ObjectString_TaxKind_Info
                                   ON ObjectString_TaxKind_Info.ObjectId = ObjectLink_TaxKind.ChildObjectId
                                  AND ObjectString_TaxKind_Info.DescId = zc_ObjectString_TaxKind_Info()

            --
            LEFT JOIN gpGet_Movement_OrderClient(inMovementId := Movement_Parent.Id ::Integer, -- ключ Документа
                                                inOperDate    := Movement_Parent.OperDate ::TDateTime ,
                                                inSession     := inSession ::TVarChar) AS tmpParent_Params ON Movement_Parent.Id = Movement_Parent.Id  
        WHERE Movement_Sale.Id = inMovementId
          AND Movement_Sale.DescId = zc_Movement_Sale()
          ;
    END IF;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 15.08.23         * 
 12.08.21         *
*/

-- тест
<<<<<<< HEAD
-- SELECT * FROM gpGet_Movement_Sale (inMovementId:= 812, inOperDate := '02.02.2021'::TDateTime, inSession:= '9818')
=======
-- SELECT * FROM gpGet_Movement_Sale (inMovementId:= 0, inOperDate := '02.02.2021'::TDateTime, inSession:= '9818')
>>>>>>> origin/master
