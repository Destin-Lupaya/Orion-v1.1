<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        Schema::create('cloture_activities', function (Blueprint $table) {
            $table->id();
            $table->integer('cloture_id');
            $table->integer('activity_id');
            $table->float('amount_usd')->default(0);
            $table->float('amount_cdf')->default(0);
            $table->float('stock')->default(0);
            $table->float('received_usd')->default(0);
            $table->float('received_cdf')->default(0);
            $table->float('received_stock')->default(0);
            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     *
     * @return void
     */
    public function down()
    {
        Schema::dropIfExists('cloture_activities');
    }
};
