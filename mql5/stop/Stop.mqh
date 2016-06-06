//+------------------------------------------------------------------+
//|                                                         Stop.mqh |
//|                                                   Enrico Lambino |
//|                                   http://www.cyberforexworks.com |
//+------------------------------------------------------------------+
#property copyright "Enrico Lambino"
#property link      "http://www.cyberforexworks.com"
#include <Trade\OrderInfo.mqh>
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class CStop : public CStopBase
  {
public:
                     CStop(void);
                     CStop(const string name);
                    ~CStop(void);
   virtual bool      CheckStopOrder(double &volume_remaining,const ulong ticket) const;
   virtual bool      DeleteStopOrder(const ulong ticket) const;
   virtual bool      OpenStop(COrder *order,COrderStop *orderstop,double val);
   virtual double    StopLossPrice(COrder *order,COrderStop *orderstop);
   virtual double    TakeProfitPrice(COrder *order,COrderStop *orderstop);

  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CStop::CStop(void)
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CStop::CStop(const string name)
  {
   m_name=name;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CStop::~CStop(void)
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CStop::CheckStopOrder(double &volume_remaining,const ulong ticket) const
  {
   COrderInfo ord;
   CHistoryOrderInfo h_ord;
   HistorySelect(0,TimeCurrent());
   if(ticket>0)
     {
      if(ord.Select(ticket)) return false;
      else
        {
         long state;
         h_ord.Ticket(ticket);
         if(h_ord.InfoInteger(ORDER_STATE,state))
           {
            if(h_ord.State()==ORDER_STATE_FILLED)
              {
               volume_remaining-=h_ord.VolumeInitial();
               return true;
              }
           }
         else
           {
            int total= HistoryOrdersTotal();
            for(int i=0;i<total;i++)
              {
               ulong t=HistoryOrderGetTicket(i);
               if(t==ticket)
                 {
                  if(h_ord.InfoInteger(ORDER_STATE,state))
                    {
                     if(state==ORDER_STATE_FILLED)
                       {
                        volume_remaining-=h_ord.VolumeInitial();
                        return true;
                       }
                    }
                 }
              }
           }
        }
     }
   return false;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CStop::DeleteStopOrder(const ulong ticket) const
  {
   if(ticket<=0) return true;
   if(m_trade.OrderDelete(ticket))
     {
      uint result=m_trade.ResultRetcode();
      if(result==TRADE_RETCODE_DONE || result==TRADE_RETCODE_PLACED)
         return true;
     }
   return false;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double CStop::TakeProfitPrice(COrder *order,COrderStop *orderstop)
  {
   double val=m_takeprofit>0?TakeProfitCalculate(order.Symbol(),order.OrderType(),order.Price()):TakeProfitCustom(order.OrderType(),order.Price());
   if((m_stop_type==STOP_TYPE_PENDING || m_main) && (val>0.0))
      if(OpenStop(order,orderstop,val))
         orderstop.TakeProfitTicket(m_trade.ResultOrder());
   return val==0?val:NormalizeDouble(val,m_symbol.Digits());
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double CStop::StopLossPrice(COrder *order,COrderStop *orderstop)
  {
   double val=m_stoploss>0?StopLossCalculate(order.Symbol(),order.OrderType(),order.Price()):StopLossCustom(order.OrderType(),order.Price());
   if((m_stop_type==STOP_TYPE_PENDING || m_main) && (val>0.0))
      if(OpenStop(order,orderstop,val))
         orderstop.StopLossTicket(m_trade.ResultOrder());
   return val==0?val:NormalizeDouble(val,m_symbol.Digits());
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CStop::OpenStop(COrder *order,COrderStop *orderstop,double val)
  {
   if(val==0) return false;
   bool res=false;
   double lotsize=LotSizeCalculate(order,orderstop);
   ENUM_ORDER_TYPE type=orderstop.MainTicketType();
   if(m_stop_type==STOP_TYPE_PENDING || m_main)
     {
      if(type==ORDER_TYPE_BUY || type==ORDER_TYPE_BUY_STOP || type==ORDER_TYPE_BUY_LIMIT)
        {
         res=m_trade.Sell(lotsize,val,0,0,m_comment);
        }
      else if(type==ORDER_TYPE_SELL || type==ORDER_TYPE_SELL_STOP || type==ORDER_TYPE_SELL_LIMIT)
        {
         res=m_trade.Buy(lotsize,val,0,0,m_comment);
        }
     }
   return res;
  }
//+------------------------------------------------------------------+
