-- Function: lpUpdate_Object_Client_Total (Integer, Integer)

DROP FUNCTION IF EXISTS lpUpdate_Object_Client_Total (Integer, Boolean, Integer);

CREATE OR REPLACE FUNCTION lpUpdate_Object_Client_Total(
    IN inMovementId          Integer   ,   -- ���� ������� <��������>
    IN inIsComplete          Boolean   ,   -- ���������� ��/��� (���� �� ��������� ����� �������... ����� �������) 
    IN inUserId              Integer       -- ������ ������������
)
RETURNS VOID
AS
$BODY$
   DECLARE vbMovementDescId            Integer;
   DECLARE vbClientId                  Integer;
   DECLARE vbUserId                    Integer;
   DECLARE vbOperDate                  TDateTime;
   DECLARE vbLastDate_Client           TDateTime;
   DECLARE vbTotalSummPay_Client       TFloat;
   DECLARE vbTotalCount_Client         TFloat;
   DECLARE vbTotalSumm_Client          TFloat;
   DECLARE vbTotalSummDiscount_Client  TFloat;
   DECLARE vbTotalCount                TFloat;
   DECLARE vbTotalSummPriceList        TFloat;
   DECLARE vbTotalSummChange           TFloat;
   DECLARE vbTotalSummPay              TFloat;
   DECLARE vbKoef                      TFloat;
BEGIN

   -- ������ �� ����� ��� ���������, ������, ����. (���� ������� = 1 , ���� ������� = -1 )
   SELECT Movement.DescId                                                                                              AS MovementDescId
        , CASE WHEN Object_From.DescId = zc_Object_Client() THEN MovementLinkObject_From.ObjectId
               WHEN Object_To.DescId   = zc_Object_Client() THEN MovementLinkObject_To.ObjectId
          END                                                                                                          AS ClientId
        , CASE WHEN Movement.DescId = zc_Movement_GoodsAccount() AND Object_From.DescId = zc_Object_Client() THEN 1
               WHEN Movement.DescId = zc_Movement_GoodsAccount() AND Object_To.DescId   = zc_Object_Client() THEN (-1)
               WHEN Movement.DescId = zc_Movement_Sale()     THEN 1
               WHEN Movement.DescId = zc_Movement_ReturnIn() THEN (-1)
          END   
          * CASE WHEN inIsComplete = TRUE THEN 1 ELSE (-1) END                                                         AS Koef
          INTO vbMovementDescId, vbClientId, vbKoef
   FROM Movement 
        LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                     ON MovementLinkObject_From.MovementId = Movement.Id
                                    AND MovementLinkObject_From.DescId     = zc_MovementLinkObject_From()
        LEFT JOIN Object AS Object_From ON Object_From.Id = MovementLinkObject_From.ObjectId
        
        LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                     ON MovementLinkObject_To.MovementId = Movement.Id
                                    AND MovementLinkObject_To.DescId     = zc_MovementLinkObject_To()
        LEFT JOIN Object AS Object_To ON Object_To.Id = MovementLinkObject_To.ObjectId
   WHERE Movement.Id = inMovementId;
   
   -- �������� ������ �� �������
   SELECT COALESCE (ObjectFloat_TotalCount.ValueData, 0)           AS TotalCount         -- ����� ����������
        , COALESCE (ObjectFloat_TotalSumm.ValueData, 0)            AS TotalSumm          -- ����� �����
        , COALESCE (ObjectFloat_TotalSummDiscount.ValueData, 0)    AS TotalSummDiscount  -- ����� ����� ������
        , COALESCE (ObjectFloat_TotalSummPay.ValueData, 0)         AS TotalSummPay       -- ����� ����� ������
        , COALESCE (ObjectDate_LastDate.ValueData, zc_DateStart()) AS LastDate           -- ��������� ���� �������
          INTO vbTotalCount_Client, vbTotalSumm_Client, vbTotalSummDiscount_Client, vbTotalSummPay_Client, vbLastDate_Client
   FROM Object AS Object_Client
        LEFT JOIN ObjectFloat AS ObjectFloat_TotalCount 
                              ON ObjectFloat_TotalCount.ObjectId = Object_Client.Id 
                             AND ObjectFloat_TotalCount.DescId = zc_ObjectFloat_Client_TotalCount()

        LEFT JOIN ObjectFloat AS ObjectFloat_TotalSumm 
                              ON ObjectFloat_TotalSumm.ObjectId = Object_Client.Id 
                             AND ObjectFloat_TotalSumm.DescId   = zc_ObjectFloat_Client_TotalSumm()

        LEFT JOIN ObjectFloat AS ObjectFloat_TotalSummDiscount 
                              ON ObjectFloat_TotalSummDiscount.ObjectId = Object_Client.Id 
                             AND ObjectFloat_TotalSummDiscount.DescId   = zc_ObjectFloat_Client_TotalSummDiscount()

        LEFT JOIN ObjectFloat AS ObjectFloat_TotalSummPay 
                              ON ObjectFloat_TotalSummPay.ObjectId = Object_Client.Id 
                             AND ObjectFloat_TotalSummPay.DescId   = zc_ObjectFloat_Client_TotalSummPay()

        LEFT JOIN ObjectDate AS ObjectDate_LastDate 
                             ON ObjectDate_LastDate.ObjectId = Object_Client.Id 
                            AND ObjectDate_LastDate.DescId   = zc_ObjectDate_Client_LastDate()
   WHERE Object_Client.Id = vbClientId;

   -- �������� ������ ���.������� : ���-��, �����, ����� ������, ����� ������, ����, ������������
   SELECT COALESCE (MD_Insert.ValueData, Movement.OperDate)                 AS OperDate            -- ����/����� ��������, � ��� ����� - ���� ���������
        , COALESCE (CASE WHEN Movement.DescId = zc_Movement_GoodsAccount() THEN 0 ELSE MovementFloat_TotalCount.ValueData END, 0)         * vbKoef AS TotalCount          -- ���-��
        , COALESCE (CASE WHEN Movement.DescId = zc_Movement_GoodsAccount() THEN 0 ELSE MovementFloat_TotalSummPriceList.ValueData END, 0) * vbKoef AS TotalSummPriceList  -- �����
        , COALESCE (MovementFloat_TotalSummChange.ValueData, 0)    * vbKoef AS TotalSummChange     -- ����� ������
        , COALESCE (MovementFloat_TotalSummPay.ValueData, 0)       * vbKoef AS TotalSummPay        -- ����� ������
        , MLO_Insert.ObjectId                                               AS UserId              -- ������������
          INTO vbOperDate, vbTotalCount, vbTotalSummPriceList, vbTotalSummChange, vbTotalSummPay, vbUserId
   FROM Movement
        LEFT JOIN MovementFloat AS MovementFloat_TotalCount
                                ON MovementFloat_TotalCount.MovementId = Movement.Id
                               AND MovementFloat_TotalCount.DescId     = zc_MovementFloat_TotalCount()

        LEFT JOIN MovementFloat AS MovementFloat_TotalSummPriceList
                                ON MovementFloat_TotalSummPriceList.MovementId = Movement.Id
                               AND MovementFloat_TotalSummPriceList.DescId     = zc_MovementFloat_TotalSummPriceList()

        LEFT JOIN MovementFloat AS MovementFloat_TotalSummChange
                                ON MovementFloat_TotalSummChange.MovementId = Movement.Id
                               AND MovementFloat_TotalSummChange.DescId     = zc_MovementFloat_TotalSummChange()

        LEFT JOIN MovementFloat AS MovementFloat_TotalSummPay
                                ON MovementFloat_TotalSummPay.MovementId = Movement.Id
                               AND MovementFloat_TotalSummPay.DescId     = zc_MovementFloat_TotalSummPay()

        LEFT JOIN MovementLinkObject AS MLO_Insert
                                     ON MLO_Insert.MovementId = Movement.Id
                                    AND MLO_Insert.DescId     = zc_MovementLinkObject_Insert()
        LEFT JOIN MovementDate AS MD_Insert
                               ON MD_Insert.MovementId = Movement.Id
                              AND MD_Insert.DescId     = zc_MovementDate_Insert()

        LEFT JOIN Object AS Object_Insert ON Object_Insert.Id = MLO_Insert.ObjectId
   WHERE Movement.Id = inMovementId;
     
   -- ��������� �������� �����
   -- ��������� <����� ����������>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_Client_TotalCount(), vbClientId, vbTotalCount_Client + vbTotalCount);
   -- ��������� <����� �����>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_Client_TotalSumm(), vbClientId, vbTotalSumm_Client + vbTotalSummPriceList);
   -- ��������� <����� ����� ������>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_Client_TotalSummDiscount(), vbClientId, vbTotalSummDiscount_Client + vbTotalSummChange);
   -- ��������� <����� ����� ������>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_Client_TotalSummPay(), vbClientId, vbTotalSummPay_Client + vbTotalSummPay);
        
        
   -- ���� ��� ������� � ���� ��������� ������ ����������� � ������� ��������� ������ ��������� �������
   IF vbMovementDescId = zc_Movement_Sale() AND inIsComplete = TRUE AND vbOperDate > vbLastDate_Client
   THEN
       -- ��������� <���������� � ��������� �������>
       PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_Client_LastCount(), vbClientId, vbTotalCount);
       -- ��������� <����� ��������� �������>
       PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_Client_LastSumm(), vbClientId, vbTotalSummPriceList);
       -- ��������� <����� ������ � ��������� �������>
       PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_Client_LastSummDiscount(), vbClientId, vbTotalSummChange);
       -- ��������� <��������� ���� �������>
       PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_Client_LastDate(), vbClientId, vbOperDate);
       -- ��������� ����� � <������������ ��� ���������� ��������� �������>
       PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_Client_LastUser(), vbClientId, vbUserId);      
   END IF;
   
   -- ���� ��� ���.������� �������������/������� � ���� ��������� ������ ����������� � ������� ��������� ������ ��������� �������
   IF vbMovementDescId = zc_Movement_Sale() AND inIsComplete = FALSE AND vbOperDate > vbLastDate_Client
   THEN
       -- ������� ������ �� ���������� ���.�������
       SELECT Movement.OperDate                                        AS OperDate            -- ����/����� ��������, � ��� ����� - ���� ���������
            , COALESCE (MovementFloat_TotalCount.ValueData, 0)         AS TotalCount          -- ���-��
            , COALESCE (MovementFloat_TotalSummPriceList.ValueData, 0) AS TotalSummPriceList  -- �����
            , COALESCE (MovementFloat_TotalSummChange.ValueData, 0)    AS TotalSummChange     -- ����� ������
            , COALESCE (MovementFloat_TotalSummPay.ValueData, 0)       AS TotalSummPay        -- ����� ������
            , MLO_Insert.ObjectId                                      AS UserId              -- ������������
              INTO vbOperDate, vbTotalCount, vbTotalSummPriceList, vbTotalSummChange, vbTotalSummPay, vbUserId
       FROM (SELECT Movement.Id
                  , COALESCE (MD_Insert.ValueData, Movement.OperDate) AS OperDate
             FROM Movement
                  INNER JOIN MovementLinkObject AS MovementLinkObject_To
                                                ON MovementLinkObject_To.MovementId = Movement.Id
                                               AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
                                               AND MovementLinkObject_To.ObjectId = vbClientId
                  LEFT JOIN MovementDate AS MD_Insert
                                         ON MD_Insert.MovementId = Movement.Id
                                        AND MD_Insert.DescId     = zc_MovementDate_Insert()
             WHERE Movement.StatusId = zc_Enum_Status_Complete() 
               AND Movement.DescId = zc_Movement_Sale()
             ORDER BY MD_Insert.ValueData DESC -- ��� �������� - ��� Movement.OperDate
             LIMIT 1
            ) AS Movement
            
            LEFT JOIN MovementFloat AS MovementFloat_TotalCount
                                    ON MovementFloat_TotalCount.MovementId = Movement.Id
                                   AND MovementFloat_TotalCount.DescId     = zc_MovementFloat_TotalCount()
                                   
            LEFT JOIN MovementFloat AS MovementFloat_TotalSummPriceList
                                    ON MovementFloat_TotalSummPriceList.MovementId = Movement.Id
                                   AND MovementFloat_TotalSummPriceList.DescId     = zc_MovementFloat_TotalSummPriceList()
                                   
            LEFT JOIN MovementFloat AS MovementFloat_TotalSummChange
                                    ON MovementFloat_TotalSummChange.MovementId = Movement.Id
                                   AND MovementFloat_TotalSummChange.DescId     = zc_MovementFloat_TotalSummChange()
                                   
            LEFT JOIN MovementFloat AS MovementFloat_TotalSummPay
                                    ON MovementFloat_TotalSummPay.MovementId = Movement.Id
                                   AND MovementFloat_TotalSummPay.DescId     = zc_MovementFloat_TotalSummPay()
    
            LEFT JOIN MovementLinkObject AS MLO_Insert
                                         ON MLO_Insert.MovementId = Movement.Id
                                        AND MLO_Insert.DescId     = zc_MovementLinkObject_Insert()
            LEFT JOIN Object AS Object_Insert ON Object_Insert.Id = MLO_Insert.ObjectId
       ;
       
       -- ��������� <���������� � ��������� �������>
       PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_Client_LastCount(), vbClientId, vbTotalCount);
       -- ��������� <����� ��������� �������>
       PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_Client_LastSumm(), vbClientId, vbTotalSummPriceList);
       -- ��������� <����� ������ � ��������� �������>
       PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_Client_LastSummDiscount(), vbClientId, vbTotalSummChange);
       -- ��������� <��������� ���� �������>
       PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_Client_LastDate(), vbClientId, vbOperDate);
       -- ��������� ����� � <������������ ��� ���������� ��������� �������>
       PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_Client_LastUser(), vbClientId, vbUserId); 
            
   END IF;
   
   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (vbClientId, inUserId);
   
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;


/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.    ��������� �.�.
23.07.17          *
*/

-- ����
-- 
--select lpUpdate_Object_Client_Total (29, FALSE, 2);
--select lpUpdate_Object_Client_Total (29, TRUE, 2);
