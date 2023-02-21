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
        Schema::create('caution_histories', function (Blueprint $table) {
            $table->id();
            $table->bigInteger('external_clients_id');
            $table->bigInteger('activity_id')->nullable();
            $table->bigInteger('account_id');
            $table->float('amount');
            $table->string('currency')->nullable()->default('USD');
            $table->text('motif')->nullable();
            $table->string('type_operation');
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
        Schema::dropIfExists('caution_histories');
    }
};
