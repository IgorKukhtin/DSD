-- Function: gpReport_JuridicalCollation()

DROP FUNCTION IF EXISTS gpReport_JuridicalBalance (TDateTime, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_JuridicalBalance(
    IN inOperDate         TDateTime , -- 
    IN inJuridicalId      Integer,    -- ����������� ����  
   OUT StartBalance       TFloat, 
   OUT OurFirm            TVarChar,
    IN inSession          TVarChar    -- ������ ������������
)
AS
$BODY$
  
BEGIN

     -- �������� ���� ������������ �� ����� ���������
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Report_Fuel());

     -- ���� ������, ������� ������� ������� � ��������. 
     -- ������� ������ - ����� ����������. �������� ���������� �� ������ ������ 20400 ��� ������� � 30500 ��� �������� �������
  SELECT SUM(Amount) INTO StartBalance
    FROM  (SELECT  Container.Amount - SUM(MIContainer.Amount) AS Amount
             FROM ContainerLinkObject AS CLO_Juridical 
                  JOIN Container ON Container.Id = CLO_Juridical.ContainerId
                  JOIN MovementItemContainer AS MIContainer 
                    ON MIContainer.Containerid = Container.Id
                   AND MIContainer.OperDate > inOperDate
            WHERE CLO_Juridical.ObjectId = inJuridicalId 
            GROUP BY Container.Amount, Container.Id) AS Balance;
            
   OurFirm  := '"���" ����';        
                                  
    -- �����. �������� ��������� ������. 
    -- ����� �������

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpReport_JuridicalBalance (TDateTime, Integer, TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 18.02.14                        * 
*/

-- ����
-- SELECT * FROM gpReport_Fuel (inStartDate:= '01.01.2013', inEndDate:= '01.02.2013', inFuelId:= null, inCarId:= null, inBranchId:= null,inSession:= '2'); 
                                                                
