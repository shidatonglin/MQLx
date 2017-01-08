//+------------------------------------------------------------------+
//|                                                       Expert.mqh |
//|                                                   Enrico Lambino |
//|                             https://www.mql5.com/en/users/iceron |
//+------------------------------------------------------------------+
#property copyright "Enrico Lambino"
#property link      "https://www.mql5.com/en/users/iceron"
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class CExpertAdvisor : public CExpertAdvisorBase
  {
public:
                     CExpertAdvisor(void);
                    ~CExpertAdvisor(void);              
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CExpertAdvisor::CExpertAdvisor(void)
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CExpertAdvisor::~CExpertAdvisor(void)
  {
  }
bool CExpertAdvisor::OnTick(void)
  {
   bool ret = CExpertAdvisorBase::OnTick();
   OnTradeTransaction();
   return ret;
  }
//+------------------------------------------------------------------+
