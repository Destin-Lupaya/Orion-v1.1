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
        Schema::create('billetages', function (Blueprint $table) {
            $table->id();
            $table->bigInteger('cloture_account_id')->unsigned();
            $table->string('billet');
            $table->text('nombre');
            $table->text('commentaire')->nullable();
            $table->integer('valid')->default(0);
            $table->integer('invalid')->default(0);
            $table->timestamps();
            $table->foreign('cloture_account_id')->references('id')->on('cloture_accounts')->onDelete('cascade');
        });
    }

    /**
     * Reverse the migrations.
     *
     * @return void
     */
    public function down()
    {
        Schema::dropIfExists('billetages');
    }
};
