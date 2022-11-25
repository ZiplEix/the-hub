<script>
    import Header from '$lib/Header.svelte';

    export let data;
    $: subs = data.subs;
</script>

<Header />
<div class="main">
        {#each subs as sub (sub.id)}
            <a href={`/${sub.id}`} class="link">
                <div class="sub">
                    <div class="note">
                        <p>{sub.id}</p>
                    </div>
                    <div class="sub-content">
                        <p class="title">{sub.title}</p>
                        <p class="content">{sub.body}</p>
                    </div>
                </div>
            </a>
        {/each}
</div>

<style>
    .main {
        display: flex;
        flex-direction: column;
        justify-content: center;
        margin: 1em;
    }
    .link {
        text-decoration: none;
        color: black;
    }
    .note {
        background: red;
        min-width: 50px;
        max-width: 50px;
        height: 50px;
        border-radius: 50%;
        font-size: 1.2em;
        margin-right: 1em;

        display: flex;
        justify-content: center;
        align-items: center;
    }
    .sub {
        display: flex;
        flex-direction: row;
        align-items: center;

        margin: 10px 0;
        padding-left: 1em;

        width: 97%;
        border: 3px solid #000;
        border-radius: 15px;
    }
    .sub:hover {
        background: rgb(237, 237, 237);
    }
    .title {
        font-size: 1.5em;
    }
</style>