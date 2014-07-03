//+------------------------------------------------------------------+
//|                                                SignalManager.mqh |
//|                        Copyright 2014, MetaQuotes Software Corp. |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2014, MetaQuotes Software Corp."
#property link      "http://www.mql5.com"
#property version   "1.00"
#include <Arrays\ArrayObj.mqh>
#include <Arrays\ArrayInt.mqh>
#include <traderjet\Signal.mqh>
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class JSignalManager: public JSignal
  {
private:
protected:
   int               m_last_signal;
   bool              m_new_signal;
public:
                     JSignalManager();
                    ~JSignalManager();
   virtual bool      AddSignal(JSignal *signal);
   virtual int       LastSignal();
   virtual void      LastSignal(int signal);
   virtual bool      InitSignals();
   virtual int       CheckSignals();
   virtual bool      DeinitSignals();
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JSignalManager::JSignalManager()
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JSignalManager::~JSignalManager()
  {
  }
//+------------------------------------------------------------------+
int JSignalManager::CheckSignals()
  {
   int res=CMD_NEUTRAL;
   int total=Total();

   for(int i=0;i<total;i++)
     {
      JSignal *signal=At(i);
      if(signal==NULL) continue;
      int ret=signal.CheckSignal();
      if(ret==CMD_VOID) return(CMD_VOID);
      if(ret==CMD_ALL) return(CMD_ALL);
      if(res>0 && ret!=res) return (CMD_VOID);
      if(ret>0) res=ret;
     }
   if(m_reverse)
      res=SignalReverse(res);
   if(m_new_signal)
      if(res==m_last_signal)
         res=CMD_VOID;
   if(res>0)
      m_last_signal=res;
   return(res);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool JSignalManager::InitSignals()
  {
   return(true);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool JSignalManager::AddSignal(JSignal *signal)
  {
   Add(signal);
   return(true);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool JSignalManager::DeinitSignals()
  {
   /*
   int total=Total();
   for(int i=0;i<total;i++)
     {
      JSignal *signal=At(i);
      if(signal==NULL) continue;
      delete signal;
     }
   */
   return(true);
  }
//+------------------------------------------------------------------+
int JSignalManager::LastSignal()
  {
   return(m_last_signal);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void JSignalManager::LastSignal(int signal)
  {
   m_last_signal=signal;
  }
//+------------------------------------------------------------------+
