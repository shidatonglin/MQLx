//+------------------------------------------------------------------+
//|                                                   CandleBase.mqh |
//|                                                   Enrico Lambino |
//|                                   http://www.cyberforexworks.com |
//+------------------------------------------------------------------+
#property copyright "Enrico Lambino"
#property link      "http://www.cyberforexworks.com"
#include <Files\FileBin.mqh>
#include "..\lib\SymbolInfo.mqh"
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class JCandleBase : public CObject
  {
protected:
   bool              m_new;
   bool              m_wait_for_new;
   bool              m_trade_processed;
   int               m_period;
   MqlRates          m_last;
   CSymbolInfo      *m_symbol;
public:
                     JCandleBase(void);
                    ~JCandleBase(void);
   virtual bool      Init(CSymbolInfo *symbol,int timeframe);
   //--- setters and getters
   datetime          LastTime(void) const {return m_last.time;}
   double            LastOpen(void) const {return m_last.open;}
   double            LastHigh(void) const {return m_last.high;}
   double            LastLow(void) const {return m_last.low;}
   double            LastClose(void) const {return m_last.close;}
   string            SymbolName(void) const {return m_symbol.Name();}
   int               Timeframe(void) const {return m_period;}
   //--- processing
   virtual bool      TradeProcessed(void) const {return m_trade_processed;}
   virtual void      TradeProcessed(bool processed) {m_trade_processed=processed;}
   virtual void      Check(void);
   virtual bool      IsNewCandle(void);
   virtual bool      Compare(MqlRates &rates) const;
   //--- recovery
   virtual bool      Save(const int handle);
   virtual bool      Load(const int handle);
  };
//+------------------------------------------------------------------+
JCandleBase::JCandleBase(void) : m_wait_for_new(false),
                                 m_trade_processed(false)
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JCandleBase::~JCandleBase(void)
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool JCandleBase::Init(CSymbolInfo *symbol,int timeframe)
  {
   m_symbol = symbol;
   m_period = timeframe;
   return true;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void JCandleBase::Check(void)
  {
   m_new=false;
   if(m_symbol!=NULL)
     {
      MqlRates rates[];
      if(CopyRates(m_symbol.Name(),(ENUM_TIMEFRAMES)m_period,1,1,rates)==-1)
         return;
      if(m_wait_for_new && m_last.time==0)
         m_last=rates[0];
      else if(Compare(rates[0]))
        {
         m_new=true;
         m_trade_processed=false;
         m_last=rates[0];
        }
     }
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool JCandleBase::IsNewCandle(void)
  {
   return m_new;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool JCandleBase::Compare(MqlRates &rates) const
  {
   return (m_last.time==0 || m_last.time!=rates.time ||
           (m_last.close/m_symbol.TickSize())!=(rates.close/m_symbol.TickSize()) || 
           (m_last.open/m_symbol.TickSize())!=(rates.open/m_symbol.TickSize()));
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool JCandleBase::Save(const int handle)
  {
   ADT::WriteBool(handle,m_trade_processed);
   ADT::WriteStruct(handle,m_last);
   return true;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool JCandleBase::Load(const int handle)
  {
   ADT::ReadBool(handle,m_trade_processed);
   ADT::ReadStruct(handle,m_last);
   return true;
  }
//+------------------------------------------------------------------+
#ifdef __MQL5__
#include "..\..\mql5\candle\Candle.mqh"
#else
#include "..\..\mql4\candle\Candle.mqh"
#endif
//+------------------------------------------------------------------+
