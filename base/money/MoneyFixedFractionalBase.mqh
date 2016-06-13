//+------------------------------------------------------------------+
//|                                     MoneyFixedFractionalBase.mqh |
//|                                                   Enrico Lambino |
//|                             https://www.mql5.com/en/users/iceron |
//+------------------------------------------------------------------+
#property copyright "Enrico Lambino"
#property link      "https://www.mql5.com/en/users/iceron"
#include "MoneyBase.mqh"
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class CMoneyFixedFractionalBase : public CMoney
  {
protected:
   double            m_risk_percent;
public:
                     CMoneyFixedFractionalBase(void);
                    ~CMoneyFixedFractionalBase(void);
   virtual bool      Validate(void);
   virtual void      UpdateLotSize(const string,const double,const ENUM_ORDER_TYPE,const double);
   void              RiskPercent(const double percent) {m_risk_percent=percent;}
   double            RiskPercent(void) const {return m_risk_percent;}
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CMoneyFixedFractionalBase::CMoneyFixedFractionalBase(void)
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CMoneyFixedFractionalBase::~CMoneyFixedFractionalBase(void)
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CMoneyFixedFractionalBase::Validate(void)
  {
   if(m_risk_percent<=0)
     {
      PrintFormat(__FUNCTION__+": invalid percentage: "+(string)m_risk_percent);
      return false;
     }
   return true;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CMoneyFixedFractionalBase::UpdateLotSize(const string symbol,const double price,const ENUM_ORDER_TYPE type,const double sl)
  {
   m_symbol = m_symbol_man.Get(symbol);
   if(m_account!=NULL && m_symbol!=NULL)
     {
      double balance=m_equity==false?m_account.Balance():m_account.Equity();
      double ticks = 0;
      if(price==0.0)
        {
         if(type==ORDER_TYPE_BUY)
            ticks = MathAbs(m_symbol.Bid()-sl)/m_symbol.TickSize();
         else if(type==ORDER_TYPE_SELL)
            ticks = MathAbs(m_symbol.Ask()-sl)/m_symbol.TickSize();
        }
      else ticks = MathAbs(price-sl)/m_symbol.TickSize();
      m_volume = ((balance*(m_risk_percent/100))/ticks)/m_symbol.TickValue();
      OnLotSizeUpdated();
     }
  }
//+------------------------------------------------------------------+
#ifdef __MQL5__
#include "..\..\MQL5\Money\MoneyFixedFractional.mqh"
#else
#include "..\..\MQL4\Money\MoneyFixedFractional.mqh"
#endif
//+------------------------------------------------------------------+
