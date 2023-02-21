<?php

namespace App\Http\Resources;

use Illuminate\Http\Resources\Json\JsonResource;

class ClotureResource extends JsonResource
{


    public function toArray($request)
    {
        return [
            'id' => $this->id,
            'amount_usd' => $this->amount_usd,
            'amount_cdf' => $this->amount_cdf,
            'sender_id' => $this->sender_id,
            'receiver_id' => $this->receiver_id,
            'received_usd' => $this->received_usd,
            'received_cdf' => $this->received_cdf,
            'status' => $this->status,
            'date_send' => $this->date_send,
            'date_received' => $this->date_received,
            'created_at' => $this->created_at,
            'billetage' => $this->billetage,
            'incidents' => $this->incidents,
            'activities' => $this->activities,
        ];
    }
}
